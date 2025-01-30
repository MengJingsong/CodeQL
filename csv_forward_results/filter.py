import csv
import os

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
    # 获取当前工作目录
    current_dir = os.getcwd()
    
    # 获取当前目录的上一级目录
    parent_dir = os.path.abspath(os.path.join(current_dir, os.pardir))
    
    destination_dir = os.path.join(parent_dir, 'filtered_csv_forward_results')

    # 遍历当前目录中的所有文件
    for filename in os.listdir(current_dir):
        # 检查文件是否为 CSV 文件
        if filename.lower().endswith('.csv'):
            src_file_path = os.path.join(current_dir, filename)
            print(f"正在处理文件: {src_file_path}")
            filter_and_move_files(src_file_path, destination_dir)

    print("所有 CSV 文件已处理完毕。")