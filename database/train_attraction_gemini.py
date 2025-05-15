import time
import csv
from google import genai
from google.genai import types


API_KEY = "AIzaSyDcFG88LzgeXPBqE3-gOJ2DpKS3VO6mLh0"
client = genai.Client(api_key=API_KEY)

def load_data_from_csv(file_path):
    """從 CSV 檔案讀取資料。"""
    data = []
    with open(file_path, 'r', encoding='utf-8') as csvfile:
        reader = csv.DictReader(csvfile)  # 將每一列讀取為字典
        for row in reader:
            # 假設您的 CSV 檔案有 'input' 和 'output' 欄位
            input_text = row.get('category')
            output_text = row.get('name')
            if input_text and output_text:
                data.append({'input': input_text, 'output': output_text})
    return data

csv_file_path = 'Taipei Main Station_attractions_1000.csv_completion.csv'
travel_data = load_data_from_csv(csv_file_path)
print(f"成功讀取 {len(travel_data)} 筆資料。")

# 準備訓練資料
training_dataset = types.TuningDataset(
    examples=[
        types.TuningExample(
            text_input=item["input"],
            output=item["output"]
        )
        for item in travel_data
    ]
)

# 建立微調任務
tuning_job = client.tunings.tune(
    base_model='models/gemini-1.5-flash-001-tuning',
    training_dataset=training_dataset,
    config=types.CreateTuningJobConfig(
        epoch_count=10,
        batch_size=8,
        learning_rate=0.001,
        tuned_model_display_name="travel_recommendation_model_from_csv"
    )
)

# 等待微調完成
job_name = tuning_job.name

while True:
    tuning_job = client.tunings.get(name=job_name)
    current_state = tuning_job.state.name
    print(f"目前狀態：{current_state}")

    if current_state == "JOB_STATE_SUCCEEDED":
        print("✅ 微調完成！")
        break
    elif current_state in ["JOB_STATE_FAILED", "JOB_STATE_CANCELLED"]:
        print(f"❌ 微調失敗，狀態為：{current_state}")
        exit(1)

    time.sleep(30)


# 使用微調後的模型產生內容
response = client.models.generate_content(
    model=tuning_job.tuned_model.endpoint,
    contents='偏好自然景觀與文化的體驗，請推薦我在台北車站附近的旅遊行程。'
)
print("模型名稱: ", tuning_job.tuned_model.endpoint)
print("生成的內容：", response.text)

