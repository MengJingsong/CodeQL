import pandas as pd
import subprocess
import os
import shutil
import tempfile


line_number_forward = 12
line_number_reverse = 14

output_forward_csv = "/Users/yuangzhou/hadoop/hadoop/codeql-custom-queries-java/csv_forward_results"
output_reverse_csv = "/Users/yuangzhou/hadoop/hadoop/codeql-custom-queries-java/csv_reverse_results"
output_forward_ql = "/Users/yuangzhou/hadoop/hadoop/codeql-custom-queries-java/ql_forward_results"
output_reverse_ql = "/Users/yuangzhou/hadoop/hadoop/codeql-custom-queries-java/ql_reverse_results"
output_forward_bqrs = "/Users/yuangzhou/hadoop/hadoop/codeql-custom-queries-java/bqrs_forward_results"
output_reverse_bqrs = "/Users/yuangzhou/hadoop/hadoop/codeql-custom-queries-java/bqrs_reverse_results"

bqrs_file = "results.bqrs"
output_csv = "test_results.csv"
codeql_path = "/Users/yuangzhou/Library/Application Support/Code/User/globalStorage/github.vscode-codeql/distribution10/codeql/codeql"
workflow_file_path = "/Users/yuangzhou/hadoop/hadoop/codeql-custom-queries-java"
old_text_forward = "%IPC_MAXIMUM_RESPONSE_LENGTH"
old_text_reverse = "maxDataLength"
potential_forward_result_folder_path = "/Users/yuangzhou/hadoop/hadoop/codeql-custom-queries-java/filtered_csv_forward_results"


def decode_to_csv(bqrs_file, output_csv):
    try:
        # Decode the bqrs file
        command = ["codeql", "bqrs", "decode", bqrs_file, "--format=csv", "--output", output_csv]
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
    
def run_codeql(query_file, bqrs_output):
    try:
        # Run the CodeQL query
        command = [
            "codeql", "query", "run", query_file,
            "-d=/Users/yuangzhou/Library/Application Support/Code/User/workspaceStorage/f7eda77f8460f84645e0f6edfe28f875/GitHub.vscode-codeql/apache-hadoop/codeql_db",
            f"--output={bqrs_output}"
        ]
        subprocess.run(command, check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error running CodeQL query: {e}")
        raise
    
def modify_and_run_codeql(workflow_file_path, line_number, old_text, new_text, output_ql_dir, output_bqrs_dri, query_name):
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
        run_codeql(ql_file_path, bqrs_file_path)
        
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
    try:
        # read CSV file
        df = pd.read_csv(input_csv)

        # extract col of lexpr except "..." and ""
        lexpr_filtered = df['lexpr'][~df['lexpr'].str.contains(r'\.\.\.') & ~df['lexpr'].str.match(r'^".*"$')]
        # drop duplicates
        lexpr_unique = lexpr_filtered.drop_duplicates()

        # return duplicated and filtered list
        return lexpr_unique.tolist()
    except Exception as e:
        print(f"An error occurred while processing the lexpr column in {input_csv}: {e}")
        raise
    
# dest is the folder path, src is file path
def filter_and_move_files(src, dest):
    try:
        if not os.path.exists(dest):
            os.makedirs(dest)

        with open(src,'r') as file:
            lines = file.readlines()
        
        if not (len(lines) == 1 and lines[0].strip() == '"bexpr","col1","lexpr","col3","rexpr"'):
            filename = os.path.basename(src)
            destination_path = os.path.join(dest, filename)
            shutil.move(src, destination_path)
    except Exception as e:
        print(f"An error occurred during file filtering: {e}")
        raise  
    
if __name__ == '__main__':
    
    # 确保目录存在
    if not os.path.exists(output_forward_csv):
        os.makedirs(output_forward_csv)
    if not os.path.exists(output_reverse_csv):
        os.makedirs(output_reverse_csv)
    
    try:
        # Use Workflow 1
        
        
        # Decode bqrs to CSV
        decode_to_csv(bqrs_file, output_csv)
        
        # Filter the output CSV
        result = filter(output_csv)
        
        # Read replacement values from 'unique_results.csv'
        replacements = read_from_csv('unique_results.csv')
        
        print(f"There are {len(replacements)} config will be replaced.")
        
        # Process each replacement value
        filename = 'WorkFlow2.ql'
        workflow_file = os.path.join(workflow_file_path, filename)
        
        print("Compile Starts.")
        
        for index, replacement in enumerate(replacements):        
            # 修改并运行 CodeQL 查询
            query_name = f"forward_query_{index + 1}"
            temp_files_info = modify_and_run_codeql(workflow_file, line_number_forward, old_text_forward, replacement, output_forward_ql, output_forward_bqrs, query_name)
            
            # 解码 .bqrs 文件并保存结果到 CSV
            output_csv = os.path.join(output_forward_csv, f"result_{index + 1}.csv")
            decode_to_csv(temp_files_info['bqrs_file'], output_csv)
            
            # Copy potential results to another folder 复制到potential路径中
            filter_and_move_files(output_csv, potential_forward_result_folder_path)
            
            # Print out the result
            print(f"No. {index+1} config replaced. Check CSV file.")
            
        print("Forward Process Completed.")
        
        # iterate all CSV files
        for file_name in os.listdir(potential_forward_result_folder_path):
            if file_name.endswith(".csv"):  # only csv
                input_csv = os.path.join(potential_forward_result_folder_path, file_name)
                
                filename_reverse = 'WorkFlow3.ql'
                # get lexpr col and duplicate
                lexpr_list = process_lexpr_column(input_csv)
                original_ql_file = os.path.join(workflow_file_path, filename_reverse)
                
                # iterate every elements in lexpr col and run Codeql
                for index, new_text in enumerate(lexpr_list):
                    # 修改并运行 CodeQL 查询, 这里是step3的codeql文件
                    query_name = f"reverse_query_{file_name}_{index + 1}"
                    temp_files_info = modify_and_run_codeql(original_ql_file, line_number_reverse, old_text_reverse, new_text, output_reverse_ql, output_reverse_bqrs, query_name)
                    
                    # 解码 .bqrs 文件并保存结果到 CSV
                    output_csv = os.path.join(output_reverse_csv, f"result_{file_name}_lexpr_{index + 1}.csv")
                    decode_to_csv(temp_files_info['bqrs_file'], output_csv)
            
        print("Batch processing completed.")
        
    except Exception as e:
        print(f"Error occurred: {e}")
    finally:
        print("All queries and results are stored in real files.")