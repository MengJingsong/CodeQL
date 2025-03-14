import os
import csv
import time
import concurrent.futures

# 获取 CSV 文件目录
current_file_path = os.path.abspath(__file__)
previous_file_path = os.path.dirname(os.path.dirname(current_file_path))
CSV_DIR = os.path.join(previous_file_path, "csv_stage3_results")
OUTPUT_FILE = os.path.join(previous_file_path, "csv_with_pattern2.txt")
SCAN_INTERVAL = 600  # 每 10 分钟检查一次

def check_csv_file(file_path):
    """
    检查单个 CSV 文件是否包含数据行
    """
    try:
        with open(file_path, "r", encoding="utf-8") as f:
            reader = csv.reader(f)
            header = next(reader, None)  # 读取表头
            first_row = next(reader, None)  # 读取第一行数据
            
            if first_row:
                return file_path  # 如果存在数据行，则返回文件路径
    except Exception as e:
        print(f"无法读取文件 {file_path}: {e}")
    
    return None  # 该文件无数据行

def check_csv_files(directory):
    """
    遍历目录中的 CSV 文件，并使用多线程检查数据行
    """
    csv_files = [os.path.join(root, file)
                 for root, _, files in os.walk(directory)
                 for file in files if file.endswith(".csv")]
    
    total_files = len(csv_files)
    data_files = []

    print(f"总共发现 {total_files} 个 CSV 文件，开始检查数据...")

    # 使用多线程加速处理
    with concurrent.futures.ThreadPoolExecutor(max_workers=10) as executor:
        results = list(executor.map(check_csv_file, csv_files))

    # 过滤出包含数据的文件
    data_files = [file for file in results if file]

    # 统计并输出结果
    print(f"\n✅ 总文件数: {total_files}")
    print(f"✅ 包含数据的文件数: {len(data_files)}")
    
    if data_files:
        print("\n📌 以下 CSV 文件包含数据行:")
        for f in data_files[:10]:  # 只打印前 10 个，防止输出过多
            print(f)
    
    # 将结果写入文件
    with open(OUTPUT_FILE, "w", encoding="utf-8") as output:
        output.write("包含数据的 CSV 文件:\n")
        for file in data_files:
            output.write(file + "\n")
    
    print(f"\n✅ 结果已保存到 {OUTPUT_FILE}")
    
    return data_files, len(data_files)

if __name__ == "__main__":
    while True:
        print("\n🔄 开始新的扫描...")
        check_csv_files(CSV_DIR)
        print(f"⌛ 等待 {SCAN_INTERVAL // 60} 分钟后重新检查...\n")
        time.sleep(SCAN_INTERVAL)
