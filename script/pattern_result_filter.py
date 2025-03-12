import os
import pandas as pd

# 定义源文件夹和目标文件夹
current_file_path = os.path.abspath(__file__)
previous_file_path = os.path.dirname(os.path.dirname(current_file_path))

def find_non_empty_csv_files(root_folder):
    non_empty_files = []  # 存储包含数据的 CSV 文件名
    
    for dirpath, _, filenames in os.walk(root_folder):  # 递归遍历所有子文件夹
        for file in filenames:
            if file.endswith(".csv"):  # 只处理 CSV 文件
                file_path = os.path.join(dirpath, file)
                
                try:
                    df = pd.read_csv(file_path)  # 读取 CSV
                    print(f"Processing {file}")
                    if not df.empty and len(df) > 0:  # 确保 CSV 里面有数据行（排除 header）
                        non_empty_files.append(file_path)  # 记录非空 CSV 文件
                except Exception as e:
                    print(f"Error reading {file_path}: {e}")  # 处理可能的文件格式错误
                
    return non_empty_files
# 使用函数
#root_directory = os.path.join(previous_file_path, "csv_stage3_results") 
#root_directory = os.path.join(previous_file_path, "small_filtered_csv_results") 
#root_directory = os.path.join(previous_file_path, "filtered_csv_forward_results") 

non_empty_csv_files = find_non_empty_csv_files(root_directory)

counter = 0
# 输出所有包含数据的 CSV 文件
print("CSV files containing data:")
for file in non_empty_csv_files:
    print(file)
    counter += 1

print(f"\nTotal counter: {counter} ")
    
