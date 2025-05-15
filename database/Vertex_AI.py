import time
from google import genai
from google.genai import types


API_KEY = "AIzaSyDcFG88LzgeXPBqE3-gOJ2DpKS3VO6mLh0"
client = genai.Client(api_key=API_KEY)

for model in client.models.list():
    if 'TUNED' in model.name.upper():
        print(model.name)

# 準備訓練資料
training_dataset = types.TuningDataset(
    examples=[
        types.TuningExample(text_input=f'input {i}', output=f'output {i}')
        for i in range(5)
    ]
)

# 建立微調任務
tuning_job = client.tunings.tune(
    base_model='models/gemini-1.5-flash-001-tuning',
    training_dataset=training_dataset,
    config=types.CreateTuningJobConfig(
        epoch_count=5,
        batch_size=4,
        learning_rate=0.001,
        tuned_model_display_name="test tuned model"
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
    contents='為什麼天空是藍色的？'
)
print("模型名稱: ", tuning_job.tuned_model.endpoint)
print("生成的內容：", response.text)


