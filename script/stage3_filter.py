import os
import pandas as pd

# 获取当前脚本文件的绝对路径
current_file_path = os.path.abspath(__file__)

# 获取当前脚本文件所在的目录
current_dir = os.path.join(os.path.dirname(os.path.dirname(current_file_path)),"csv_stage3_results")

#output_dir = os.path.dirname(current_file_path)


def collect_classexpr_info(root_dir, output_stage3_csv, output_stage4_csv):
    """
    root_dir: 要遍历的根目录
    output_stage3_csv: 最终输出的汇总 CSV 文件路径
    """

    # 用于存储 classexpr 的信息
    # 结构: { classexpr_value: {"count": 总次数, "files": set(包含文件名)} }
    classexpr_dict = {}
    ifstmt_list = []

    # 使用 os.walk 递归遍历目录
    for dirpath, dirnames, filenames in os.walk(root_dir):
        for filename in filenames:
            # 只处理 .csv 文件
            if filename.lower().endswith(".csv"):
                csv_path = os.path.join(dirpath, filename)
                try:
                    # 读取 csv，假设编码为 utf-8，可根据实际情况调整
                    df = pd.read_csv(csv_path, encoding="utf-8")

                    # 如果文件中包含 classexpr 列，则处理
                    if "classexpr" in df.columns:
                        for val in df["classexpr"].dropna():
                            val_str = str(val).strip()

                            if val_str not in classexpr_dict:
                                classexpr_dict[val_str] = {
                                    "count": 0,
                                    "files": set()
                                }

                            classexpr_dict[val_str]["count"] += 1
                            classexpr_dict[val_str]["files"].add(filename)
                            
                    # 如果文件中包含有效的col1列(也就是ifstmt的地址), 则处理
                    if "col4" in df.columns:
                        for val in df['col4'].dropna():
                            val_str = str(val).strip()
                            
                            if val_str not in ifstmt_list:
                                ifstmt_list.append(val_str)
                
                except Exception as e:
                    print(f"读取文件 {csv_path} 失败: {e}")

    # 将结果转换为 DataFrame，准备写出到 CSV
    rows = []
    for classexpr_value, info in classexpr_dict.items():
        rows.append({
            "classexpr": classexpr_value,
            "count": info["count"],
            # 将文件名的 set 转换成用分号等分隔的字符串，便于存储
            "files": ";".join(sorted(list(info["files"])))
        })

    result_df = pd.DataFrame(rows, columns=["classexpr", "count", "files"])

    # 按照 count 降序排一下，便于查看
    result_df.sort_values(by="count", ascending=False, inplace=True)

    # 输出汇总 csv
    result_df.to_csv(output_stage3_csv, index=False, encoding="utf-8")
    print(f"汇总结果已输出到 {output_stage3_csv}")
    
    # 将读到的'col4'转换为DataFrame, 准备写到CSV中
    result_df = pd.DataFrame(ifstmt_list, columns=["ifstmt_location"])
    result_df.to_csv(output_stage4_csv, index=False, encoding="utf-8")
    print(f"汇总结果已输出到 {output_stage4_csv}")


if __name__ == "__main__":
    # 示例用法
    root_directory = current_dir 
    output_stage3_file = "output_direct_creation.csv"                 # 替换为想要的输出文件名
    output_stage4_file = "output_recursion.csv"
    collect_classexpr_info(root_directory, output_stage3_file, output_stage4_file)
    