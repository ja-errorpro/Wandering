from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import google.generativeai as genai
import os

API_KEY = "AIzaSyDcFG88LzgeXPBqE3-gOJ2DpKS3VO6mLh0"
TUNED_MODEL_ID = "tunedModels/travelrecommendationmodelfromcsv-3n5xa71"

genai.configure(api_key=API_KEY)

# 載入微調模型
model = genai.GenerativeModel(model_name=TUNED_MODEL_ID)

# FastAPI 初始化
app = FastAPI()

# 請求資料格式
class PromptRequest(BaseModel):
    prompt: str

# 根目錄測試
@app.get("/")
def read_root():
    return {"message": "Gemini tuned model API server is running."}

# 核心 API：處理文字輸入
@app.post("/generate")
def generate_text(req: PromptRequest):
    try:
        # 呼叫 generate_content
        response = model.generate_content(req.prompt)
        
        return {"response": response.text}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
