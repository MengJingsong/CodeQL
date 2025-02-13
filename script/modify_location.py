import pandas as pd

# 未来启用, 现在codeql_db 是旧版本的, 不是新版本的

# 读取原始结果 CSV 文件
df = pd.read_csv("output_recursion.csv")  

# 定义原始路径前缀和你本地的路径前缀
old_prefix = "file:///home/runner/work/bulk-builder/bulk-builder/hadoop-hdfs-project"
new_prefix = "file:///user/Yuang/hadoop/hadoop-hdfs-project"  # 请根据实际情况修改

# 对 ifstmt_location 列进行替换，注意如果有多个字段也可以类似处理
df["ifstmt_location"] = df["ifstmt_location"].str.replace(old_prefix, new_prefix)

# 保存修改后的 CSV 文件
df.to_csv("result_modified.csv", index=False)
print("修改后的 CSV 文件已保存为 result_modified.csv")