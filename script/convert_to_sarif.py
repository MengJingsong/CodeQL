import csv
import json
import os

# 定义源文件夹和目标文件夹
current_file_path = os.path.abspath(__file__)
previous_file_path = os.path.dirname(os.path.dirname(current_file_path))

csv_file_folder = os.path.join(os.path.join(previous_file_path, "csv_forward_results"))
sarif_file = "./result.sarif"

sarif_output = {
    "version": "2.1.0",
    "$schema": "https://json.schemastore.org/sarif-2.1.0.json",
    "runs": [
        {
            "tool": {
                "driver": {
                    "name": "CodeQL",
                    "informationUri": "https://codeql.github.com/",
                    "rules": []
                }
            },
            "results": []
        }
    ]
}

with open(csv_file, newline='', encoding='utf-8') as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        sarif_output["runs"][0]["results"].append({
            "ruleId": "CodeQL.Query",
            "message": {"text": row.get("message", "Issue found")},
            "locations": [
                {
                    "physicalLocation": {
                        "artifactLocation": {
                            "uri": row.get("file", "unknown"),
                            "uriBaseId": "SRCROOT"
                        },
                        "region": {
                            "startLine": int(row.get("line", "1")),
                            "startColumn": int(row.get("column", "1"))
                        }
                    }
                }
            ]
        })

# 保存为 SARIF
with open(sarif_file, "w", encoding="utf-8") as f:
    json.dump(sarif_output, f, indent=2)

print(f"SARIF report saved as {sarif_file}")