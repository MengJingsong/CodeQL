import os
import pandas as pd
import shutil

# 定义源文件夹和目标文件夹
current_file_path = os.path.abspath(__file__)
previous_file_path = os.path.dirname(os.path.dirname(current_file_path))

source_folder = os.path.join(previous_file_path, "filtered_csv_forward_results")
destination_folder = os.path.join(previous_file_path, "small_filtered_csv_results")

# 确保目标文件夹存在
os.makedirs(destination_folder, exist_ok=True)
counter = 0

# 遍历所有 CSV 文件
for filename in os.listdir(source_folder):
    if filename.endswith(".csv"):
        file_path = os.path.join(source_folder, filename)
        
        # 读取 CSV 文件
        try:
            df = pd.read_csv(file_path)
            # 检查行数
            if len(df) <= 20:
                # 复制文件到目标文件夹
                shutil.copy(file_path, os.path.join(destination_folder, filename))
                print(f"Copied: {filename}")
                counter+=1
        except Exception as e:
            print(f"Error processing {filename}: {e}")

print("Processing complete.")
print(f"Total number {counter}")
