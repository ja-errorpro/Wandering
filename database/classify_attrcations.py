import google.generativeai as genai
import time
import csv
import json

# 將 YOUR_API_KEY 替換成你的 API 金鑰
API_KEY = "AIzaSyDMtazU-8JHUIRATuyI5yHAAT46fm2Oiew"

# 設定 Gemini API 金鑰
genai.configure(api_key=API_KEY)

# 設定 CSV 檔案名稱
CSV_FILE = "Taipei Main Station_attractions_1000.csv"  # 假設您要讀取這個檔案

# 定義景點分類
CATEGORIES = [
    "博物館、歷史與藝術展覽",
    "地標建築、城市地標、歷史性建築",
    "市場／夜市、在地小吃與逛街熱點、老街",
    "公園／廣場、社區、綠地、野餐空間",
    "咖啡廳、文青聚點、休息放鬆",
    "藝文空間 (如書店、藝廊)、喜歡靜態、具文化氣息的場域",
    "廟宇／宗教地、宗教文化、神聖氛圍",
    "夜景觀景點、高處眺望點、夜景打卡",
    "步道／自然山林、小徑、森林、濕地等",
    "海邊／湖畔、風景優美、適合散步"
]

def classify_place(place_name, place_details, categories=CATEGORIES):
    """
    使用 Gemini API 將景點分類。
    """
    model = genai.GenerativeModel('gemini-2.0-flash')
    prompt = f"""
        請將以下景點歸類到最合適的類別：
        景點名稱：{place_name}
        景點描述：{place_details}
        可選類別：{', '.join(categories)}
        請只輸出一個類別名稱，不要包含其他文字。
        """
    try:
        time.sleep(2)
        response = model.generate_content(prompt)
        #print(response.text)
        return response.text.strip()
    except Exception as e:
        print(f"Gemini API 發生錯誤：{e}")
        return "未分類"

def process_csv(input_filename=CSV_FILE, output_filename=CSV_FILE + "_classified.csv"):
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
