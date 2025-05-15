import csv
import json

def convert_csv_to_jsonl(csv_file_path, jsonl_file_path):
    """
    將 CSV 檔案轉換為 JSONL 格式，適用於 Vertex AI 模型微調。

    Args:
        csv_file_path (str): 包含訓練資料的 CSV 檔案路徑。
        jsonl_file_path (str): 輸出 JSONL 檔案的路徑。
    """
    try:
        with open(csv_file_path, 'r', encoding='utf-8') as csvfile, \
                open(jsonl_file_path, 'w', encoding='utf-8') as jsonlfile:

            reader = csv.DictReader(csvfile)
            for row in reader:
                # 假設您的 CSV 檔案有 'prompt' 和 'completion' 欄位
                # 如果您的欄位名稱不同，請修改以下兩行
                prompt = row.get('prompt')  # 使用 .get() 以避免 KeyError
                completion = row.get('completion')

                if prompt and completion:  # 確保 prompt 和 completion 存在
                    jsonl_data = {
                        "prompt": prompt,
                        "completion": completion
                    }
                    jsonlfile.write(json.dumps(jsonl_data, ensure_ascii=False) + '\n')
                else:
                    print(f"略過 CSV 檔案中的一行，因為缺少 'prompt' 或 'completion'：{row}")

        print(f"已成功將 '{csv_file_path}' 轉換為 '{jsonl_file_path}'")

    except FileNotFoundError:
        print(f"找不到檔案：'{csv_file_path}'")
    except Exception as e:
        print(f"轉換過程中發生錯誤：{e}")

if __name__ == "__main__":
    # 將 'your_data.csv' 替換為您的 CSV 檔案路徑
    csv_file_path = 'your_data.csv'
    # 指定輸出 JSONL 檔案的路徑
    jsonl_file_path = 'output.jsonl'
    convert_csv_to_jsonl(csv_file_path, jsonl_file_path)
