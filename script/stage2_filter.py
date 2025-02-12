import os
import shutil
import pandas as pd

current_file_path = os.path.abspath(__file__)
previous_file_path = os.path.dirname(os.path.dirname(current_file_path))

filtered_csv_forward = os.path.join(previous_file_path, "filtered_csv_forward_results")
small_filtered_csv = os.path.join(previous_file_path, "small_filtered_csv_results")

# 设置源文件夹和目标文件夹
source_folder = filtered_csv_forward  # 替换为你的源文件夹路径
destination_folder = small_filtered_csv  # 替换为你的目标文件夹路径

# 确保目标文件夹存在
os.makedirs(destination_folder, exist_ok=True)

# 遍历源文件夹中的所有 CSV 文件
for filename in os.listdir(source_folder):
    if filename.endswith(".csv"):  # 只处理 CSV 文件
        file_path = os.path.join(source_folder, filename)
        
        try:
            # 读取 CSV 文件
            df = pd.read_csv(file_path)
            
            # 计算数据行数（不包括 header）
            row_count = len(df)

            # 如果数据行数少于 20，则复制到目标文件夹
            if row_count < 20:
                shutil.copy(file_path, os.path.join(destination_folder, filename))
                print(f"✅ 文件 {filename} 复制成功（数据行数: {row_count}）")

        except Exception as e:
            print(f"❌ 处理文件 {filename} 时出错: {e}")

print("🎯 处理完成！")