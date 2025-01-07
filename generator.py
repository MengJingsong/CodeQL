import xml.etree.ElementTree as ET
import os

current_dir = os.getcwd()

xml_path = os.path.join(current_dir,"hdfs-default.xml")

tree = ET.parse(xml_path)
root = tree.getroot()

params = set()

for property in root.findall('property'):
    name = property.find('name')
    if name is not None:
        params.add(name.text.strip())

# 将参数名称写入文件
with open('core_params_hdfs.txt', 'w') as f:
    for i, param in enumerate(sorted(params)):
        if i == len(params) - 1:
            # 特别处理最后一个元素
            f.write(f's = "{param}"\n')
        else:
            # 处理其他元素
            f.write(f's = "{param}" or\n')