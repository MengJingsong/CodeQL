import pandas as pd
import subprocess
import os
import shutil
import tempfile
import platform
import glob
import csv
from tqdm import tqdm

current_dir = os.getcwd()

line_number_forward = 12
line_number_reverse_left = 22
line_number_reverse_right = 18

# 基于当前工作目录设置路径
output_forward_csv = os.path.join(current_dir, "csv_forward_results")
output_reverse_csv = os.path.join(current_dir, "csv_reverse_results")
output_forward_ql = os.path.join(current_dir, "ql_forward_results")
output_reverse_ql = os.path.join(current_dir, "ql_reverse_results")
output_forward_bqrs = os.path.join(current_dir, "bqrs_forward_results")
output_reverse_bqrs = os.path.join(current_dir, "bqrs_reverse_results")
potential_forward_result_folder_path = os.path.join(current_dir, "filtered_csv_forward_results")

bqrs_file = "results.bqrs"
output_csv = "test_results.csv"
workflow_file_path = current_dir  # 当前目录的子文件夹
old_text_forward = "%IPC_MAXIMUM_RESPONSE_LENGTH"
old_text_reverse_right = "maxDataLength"
old_text_reverse_left = "dataLength"


import os
import platform

def get_codeql_db_path(project_name="apache-hadoop"):

    system_name = platform.system()
    user_home = os.path.expanduser("~")  # 用户主目录

    # 不同系统的默认路径前缀
    if system_name == "Darwin":  # macOS
        base_path = os.path.join(user_home, "Library", "Application Support", "Code", "User", "workspaceStorage")
    elif system_name == "Linux":
        base_path = os.path.join(user_home, ".config", "Code", "User", "workspaceStorage")
    elif system_name == "Windows":
        base_path = os.path.join(user_home, "AppData", "Roaming", "Code", "User", "workspaceStorage")
    else:
        raise RuntimeError(f"Unsupported operating system: {system_name}")

    # 搜索 workspaceStorage 下的所有子目录，寻找匹配的项目路径
    if os.path.exists(base_path):
        for subdir in os.listdir(base_path):
            potential_path = os.path.join(base_path, subdir, "GitHub.vscode-codeql", project_name, "codeql_db")
            if os.path.exists(potential_path):
                print(f"Detected CodeQL database path: {potential_path}")
                return potential_path

    # 如果未找到路径，抛出异常或提示用户手动输入
    raise FileNotFoundError(f"CodeQL database for project '{project_name}' not found in default locations. "
                            "Please ensure the database exists or specify the path manually.")

# 自动推导 CodeQL 的安装路径
def get_codeql_path():
    system_name = platform.system()  # 获取操作系统名称

    if system_name == "Darwin":  # macOS 系统
        # macOS 上常见的 CodeQL 路径
        base_path = os.path.expanduser("~/Library/Application Support/Code/User/globalStorage/github.vscode-codeql/")
        possible_paths = [
            os.path.expanduser("~/codeql/codeql"),  # 手动安装路径
            "/usr/local/bin/codeql"  # 全局路径
        ]
        
        # 动态查找 `distribution` 目录
        distribution_glob = os.path.join(base_path, "distribution*/codeql/codeql")
        matching_paths = glob.glob(distribution_glob)
        if matching_paths:
            possible_paths.extend(matching_paths)  # 添加匹配到的路径
    elif system_name == "Linux":
        # Linux 上常见的 CodeQL 路径
        possible_paths = [
            os.path.expanduser("~/.codeql/codeql"),  # 手动安装
            "/usr/local/bin/codeql"
        ]
    elif system_name == "Windows":
        # Windows 上常见的 CodeQL 路径
        possible_paths = [
            os.path.expanduser("~/AppData/Roaming/CodeQL/codeql"),  # 用户安装路径
            "C:\\Program Files\\CodeQL\\codeql.exe"  # 系统全局路径
        ]
    else:
        raise RuntimeError(f"Unsupported operating system: {system_name}")

    # 检查路径是否存在
    for path in possible_paths:
        if os.path.exists(path):
            print(f"Detected CodeQL path: {path}")
            return path

    raise FileNotFoundError("CodeQL executable not found. Please install CodeQL or specify the path manually.")


# Ensure all required directories exist
def ensure_directories_exist(directories):
    for directory in directories:
        if not os.path.exists(directory):
            os.makedirs(directory)
            print(f"Created directory: {directory}")
        else:
            print(f"Directory already exists: {directory}")

def decode_to_csv(bqrs_file, output_csv, codeql_path):
    try:
        # Decode the bqrs file
        command = [codeql_path, "bqrs", "decode", bqrs_file, "--format=csv", "--output", output_csv]
        subprocess.run(command, check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error in decoding bqrs file: {e}")
        raise    

def filter(output_csv):
    try:
        # Load the CSV data and drop duplicates
        df = pd.read_csv(output_csv)
        
        # 标准化：去掉 'xxx.' 前缀，只保留最后的部分
        df['sink'] = df['sink'].str.replace(r'.*\.', '', regex=True)
        
        # 过滤小写字母开头的行
        filtered_col = df[~df['sink'].str.match(r'^[a-z]')]['sink']
        
        # 去重
        unique_filtered_col = filtered_col.drop_duplicates()
        
        unique_filtered_col.to_csv('unique_results.csv', index=False, header=False)
        return len(unique_filtered_col)
    except Exception as e:
        print(f"Error in processing CSV: {e}")
        raise
    
def run_codeql(query_file, bqrs_output, codeql_path, codeql_db_path):
    try:
        # Run the CodeQL query
        command = [
            codeql_path,
            "query", "run",
            query_file,
            "-d", codeql_db_path,
            f"--output={bqrs_output}"
        ]
        subprocess.run(command, check=True)
        print(f"Successfully ran CodeQL query: {query_file}")
    except subprocess.CalledProcessError as e:
        print(f"Error running CodeQL query: {e}")
        raise
    
def modify_and_run_codeql(workflow_file_path, line_number, old_text, new_text, output_ql_dir, output_bqrs_dri, query_name, codeql_path, codeqldb_path):
    try:
        # read all lines in file
        with open(workflow_file_path, 'r') as file:
            lines = file.readlines()
        
        # modify specific line
        if line_number <= len(lines):  
            if old_text in lines[line_number - 1]:  
                lines[line_number - 1] = lines[line_number - 1].replace(old_text, '%'+new_text)
            else:
                print(f"'{old_text}' not found in line {line_number}.")
                
        # 生成真实的 .ql 文件
        ql_file_path = os.path.join(output_ql_dir, f"{query_name}.ql")
        with open(ql_file_path, 'w') as file:
            file.writelines(lines)
        print(f"Created QL file: {ql_file_path}")
        
        # 生成 .bqrs 输出文件路径
        bqrs_file_path = os.path.join(output_bqrs_dri, f"{query_name}.bqrs")

        # 运行 CodeQL 查询
        run_codeql(ql_file_path, bqrs_file_path, codeql_path, codeqldb_path)
        
        # 返回文件路径
        return {"ql_file": ql_file_path, "bqrs_file": bqrs_file_path}
    except Exception as e:
        print(f"An error occurred while modifying and running CodeQL: {e}")
        raise
    
def modify_and_run_codeql_twice(workflow_file_path, line_number_left, line_number_right, old_text_left, old_text_right, new_text_left, new_text_right, output_ql_dir, output_bqrs_dri, query_name, codeql_path, codeqldb_path):
    try:
        # read all lines in file
        with open(workflow_file_path, 'r') as file:
            lines = file.readlines()
                
        # modify specific line IN WORKFLOW3 先右边的变量
        if line_number_right <= len(lines) or line_number_left <= len(lines):  
            # 先处理右边的
            if old_text_right in lines[line_number_right - 1]:  
                lines[line_number_right - 1] = lines[line_number_right - 1].replace(old_text_right, new_text_right)
            else:
                print(f"'{old_text_right}' not found in line {line_number_right}.")
            # 再处理左边的
            if old_text_left in lines[line_number_left - 1]:  
                lines[line_number_left - 1] = lines[line_number_left - 1].replace(old_text_left, new_text_left)
            else:
                print(f"'{old_text_left}' not found in line {line_number_left}.")
        
                
        # 生成真实的 .ql 文件
        ql_file_path = os.path.join(output_ql_dir, f"{query_name}.ql")
        with open(ql_file_path, 'w') as file:
            file.writelines(lines)
        print(f"Created QL file: {ql_file_path}")
        
        # 生成 .bqrs 输出文件路径
        bqrs_file_path = os.path.join(output_bqrs_dri, f"{query_name}.bqrs")

        # 运行 CodeQL 查询
        run_codeql(ql_file_path, bqrs_file_path, codeql_path, codeqldb_path)
        
        # 返回文件路径
        return {"ql_file": ql_file_path, "bqrs_file": bqrs_file_path}
    except Exception as e:
        print(f"An error occurred while modifying and running CodeQL: {e}")
        raise
    
        
def read_from_csv(input_csv):
    try:
        # Read the column values from the CSV
        df = pd.read_csv(input_csv, header=None) 
        return df[0].tolist()  # Return the first column as a list
    except Exception as e:
        print(f"Error reading from CSV: {e}")
        raise
    
def process_lexpr_column(input_csv):
    """
    过滤 lexpr 列，只保留包含至少一个大写字母的连续英文字符（非数字），
    并排除单字母值，同时确保保留 lexpr 和 rexpr 的配对关系。
    
    :param input_csv: 输入的 CSV 文件路径。
    :return: 返回过滤后的配对 (lexpr, rexpr) 列表。
    """
    try:
        # 读取 CSV 文件
        df = pd.read_csv(input_csv)

        # 检查是否存在 'lexpr' 和 'rexpr' 列
        if 'lexpr' not in df.columns or 'rexpr' not in df.columns:
            raise ValueError(f"Missing 'lexpr' or 'rexpr' column in {input_csv}.")

        # 定义正则表达式：匹配至少两个连续英文字符，且至少包含一个大写字母
        valid_pattern = r'^(?=.*[A-Z])[a-zA-Z]{2,}$'

        # 过滤 lexpr 列：匹配正则，且不为空
        filtered_df = df[df['lexpr'].str.match(valid_pattern, na=False)]

        # 同时确保 rexpr 列不为空
        filtered_df = filtered_df[filtered_df['rexpr'].notna()]

        # 如果过滤后没有数据，返回空列表
        if filtered_df.empty:
            return [], []

        # 返回 lexpr 和 rexpr 的配对列表，不去重
        return filtered_df['lexpr'].tolist(), filtered_df['rexpr'].tolist()
    except Exception as e:
        print(f"An error occurred while processing the lexpr column in {input_csv}: {e}")
        raise
    
# dest is the folder path, src is file path
def filter_and_move_files(src, dest):
    try:
        # 确保目标目录存在
        if not os.path.exists(dest):
            os.makedirs(dest)

        # 读取 CSV 文件内容
        with open(src, 'r') as file:
            reader = csv.DictReader(file)  # 使用 DictReader 方便按列名操作
            filtered_rows = []

            for row in reader:
                lexpr = row.get("lexpr", "")
                rexpr = row.get("rexpr", "")

                # 检查 lexpr 和 rexpr 是否是连续字符（不含特殊符号）
                if lexpr.isalnum() and rexpr.isalnum():
                    filtered_rows.append(row)

        # 如果过滤后的内容非空，保存到目标路径
        if filtered_rows:
            filename = os.path.basename(src)
            destination_path = os.path.join(dest, filename)

            with open(destination_path, 'w', newline='') as output_file:
                writer = csv.DictWriter(output_file, fieldnames=reader.fieldnames)
                writer.writeheader()  # 写入表头
                writer.writerows(filtered_rows)  # 写入过滤后的内容

            print(f"Filtered and moved file to: {destination_path}")
        else:
            print(f"No valid rows found in {src}. File not moved.")
    except Exception as e:
        print(f"An error occurred during file filtering: {e}")
        raise 
    
if __name__ == '__main__':
    
    # List of all directories to ensure existence
    directories_to_check = [
        output_forward_csv,
        output_reverse_csv,
        output_forward_ql,
        output_reverse_ql,
        output_forward_bqrs,
        output_reverse_bqrs,
        potential_forward_result_folder_path
    ]
    
    # Ensure directories exist
    ensure_directories_exist(directories_to_check)
    
    try:
        # get codeql path
        codeql_path = get_codeql_path()
        # get codeqldb path
        codeql_db_path = get_codeql_db_path()
        
        #--------------------------------------------
        
        print("Stage1 WorkFlow1 Start")
        
        # Use Workflow 1
        filename = 'WorkFlow1.ql'
        workflow_file = os.path.join(workflow_file_path, filename)
        
        run_codeql(workflow_file, bqrs_file, codeql_path, codeql_db_path)
        # Decode bqrs to CSV
        decode_to_csv(bqrs_file, output_csv, codeql_path)
        
        # Filter the output CSV, generate unique_results.csv
        result = filter(output_csv)
        
        # TODO: 计算这个阶段的时间, 除了w1,w2,w3
        print("Stage1 WorkFlow1 Ends")
        #--------------------------------------------
        # Workflow 2 starts
        
        print("Stage2 WorkFlow2 Start")
        
        # Read replacement values from 'unique_results.csv'
        replacements = read_from_csv('unique_results.csv')
        
        print(f"There are {len(replacements)} config will be replaced.")
        
        # Process each replacement value
        # Use Workflow 2
        filename = 'WorkFlow2.ql'
        workflow_file = os.path.join(workflow_file_path, filename)
        
        print("Compile Starts.")
        
        for index, replacement in enumerate(tqdm(replacements, desc="Workflow 2 Progress", unit="config")):         
            # 修改并运行 CodeQL 查询
            query_name = f"forward_query_{index + 1}"
            temp_files_info = modify_and_run_codeql(workflow_file, line_number_forward, old_text_forward, replacement, output_forward_ql, output_forward_bqrs, query_name, codeql_path, codeql_db_path)
            
            # 解码 .bqrs 文件并保存结果到 CSV
            output_csv = os.path.join(output_forward_csv, f"result_{index + 1}.csv")
            decode_to_csv(temp_files_info['bqrs_file'], output_csv, codeql_path)
            
            # Copy potential results to another folder 复制到potential路径中
            filter_and_move_files(output_csv, potential_forward_result_folder_path)
            
            # Print out the result
            print(f"No. {index+1} config replaced. Check CSV file.")
            
        print("Forward Process Completed.")
        print("Stage2 WorkFlow2 End")

        
        # Workflow2 ends
        #--------------------------------------------
        # Workflow3 start
        print("Stage3 WorkFlow3 Start")
        
        # 遍历 CSV 文件
        csv_files = [f for f in os.listdir(potential_forward_result_folder_path) if f.endswith(".csv")]

        # Workflow3
        # iterate all CSV files
        # Use tqdm 包装 csv_files，显示进度条
        for file_name in tqdm(csv_files, desc="Workflow 3 Progress (Files)", unit="file"):
            input_csv = os.path.join(potential_forward_result_folder_path, file_name)
            filename_reverse = 'WorkFlow3.ql'
            
            # 获取 lexpr 和 rexpr 列数据
            lexpr_list, rexpr_list = process_lexpr_column(input_csv)

            # 如果任一列表为空，跳过该文件, 因为process_lexpr返回的左边不符合
            if not lexpr_list or not rexpr_list:
                print(f"Skipping {file_name}: No valid lexpr-rexpr pairs found.")
                continue
            
            original_ql_file = os.path.join(workflow_file_path, filename_reverse)
            
            # Iterate over lexpr_list and rexpr_list simultaneously and run CodeQL
            for index, (new_text_left, new_text_right) in enumerate(
                tqdm(zip(lexpr_list, rexpr_list), desc=f"Processing {file_name}", unit="pair", leave=False, total=len(lexpr_list))
            ):
                # 修改并运行 CodeQL 查询, 这里是step3的codeql文件
                query_name = f"reverse_query_{file_name}_{index + 1}"
                temp_files_info = modify_and_run_codeql_twice(original_ql_file, line_number_reverse_left, line_number_reverse_right, old_text_reverse_left, old_text_reverse_right, new_text_left, new_text_right, output_reverse_ql, output_reverse_bqrs, query_name, codeql_path, codeql_db_path)
                
                # 解码 .bqrs 文件并保存结果到 CSV
                output_csv = os.path.join(output_reverse_csv, f"result_{file_name}_lexpr_{index + 1}.csv")
                decode_to_csv(temp_files_info['bqrs_file'], output_csv, codeql_path)
            
        print("Batch processing completed.")
        print("Stage3 WorkFlow3 End")
        
    except Exception as e:
        print(f"Error occurred: {e}")
    finally:
        print("All queries and results are stored in real files.")