import os


current_file_path = os.path.abspath(__file__)

# 获取当前脚本文件所在的目录
current_dir = os.path.dirname(current_file_path)


def count_csv_files(folder_path):
    return sum(
        1 for f in os.listdir(folder_path)
        if os.path.isfile(os.path.join(folder_path, f)) and f.lower().endswith('.csv')
    )

# 示例
potential_forward_result_folder_path = os.path.join(current_dir, 'filtered_csv_forward_results')
file_count = count_csv_files(potential_forward_result_folder_path)
print(file_count)