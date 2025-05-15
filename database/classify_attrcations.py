import google.generativeai as genai
import time
import csv
import json

# 將 YOUR_API_KEY 替換成你的 API 金鑰
API_KEY = "AIzaSyDMtazU-8JHUIRATuyI5yHAAT46fm2Oiew"

# 設定 Gemini API 金鑰
genai.configure(api_key=API_KEY)

# 設定 CSV 檔案名稱
CSV_FILE = "Taipei Main Station_attractions_100.csv"  # 假設您要讀取這個檔案

# 定義景點分類
CATEGORIES = [
    "文化體驗",
    "自然景觀", 
    "美食探索", 
    "小眾秘境", 
    "夜生活", 
    "運動戶外", 
    "購物逛街", 
    "文青藝文", 
    "親子同樂", 
    "慢活療癒"
]

def classify_place(place_name, place_details, categories=CATEGORIES):
    """
    使用 Gemini API 將景點分類。
    """
    model = genai.GenerativeModel('gemini-2.0-flash')
    prompt = f"""
        請將以下景點歸類到所有相關的類別，以逗號分隔。如果景點屬於多個類別，請全部列出。
        景點名稱：{place_name}
        景點描述：{place_details}
        可選類別：{', '.join(categories)}
        請只輸出類別名稱，不要包含其他文字，且只能在可選類別中選擇。
        """
    try:
        time.sleep(3)
        response = model.generate_content(prompt)
        # print(response.text)
        # 將結果字串分割成列表，並移除空白字串
        return [category.strip() for category in response.text.split(',') if category.strip()]
    except Exception as e:
        print(f"Gemini API 發生錯誤：{e}")
        return ["未分類"]  # 回傳一個包含 "未分類" 的列表

def process_csv(input_filename=CSV_FILE, output_filename=CSV_FILE + "_completion.csv"):
    """
    從 CSV 檔案讀取景點資料，使用 Gemini API 進行分類，然後將結果寫回 CSV 檔案。
    """
    try:
        with open(input_filename, "r", encoding="utf-8") as infile, \
                open(output_filename, "w", encoding="utf-8", newline="") as outfile:

            reader = csv.DictReader(infile)
            writer = csv.DictWriter(outfile, fieldnames=reader.fieldnames + ["category"])  # 加上 "category" 欄位
            writer.writeheader()  # 寫入標題列

            for row in reader:
                place_name = row["name"]
                details_json = row["details"]
                # 載入景點詳細資料
                try:
                    details = json.loads(details_json)
                    details_text = json.dumps(details, ensure_ascii=False)
                except json.JSONDecodeError:
                    details_text = ""

                # 使用 Gemini API 分類景點
                category = classify_place(place_name, details_text)
                row["category"] = category  # 將分類結果加入 row
                writer.writerow(row)  # 寫入包含分類結果的資料列
                print(f"景點 '{place_name}' 分類為：{category}")

        print(f"分類結果已儲存到 {output_filename}")

    except FileNotFoundError:
        print(f"找不到檔案：{input_filename}")
    except Exception as e:
        print(f"處理 CSV 檔案時發生錯誤：{e}")

if __name__ == "__main__":
    process_csv()
