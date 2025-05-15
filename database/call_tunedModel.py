import time
from google import genai
from google.genai import types


API_KEY = "AIzaSyDcFG88LzgeXPBqE3-gOJ2DpKS3VO6mLh0"
client = genai.Client(api_key=API_KEY)

response = client.models.generate_content(
    model='tunedModels/travelrecommendationmodelfromcsv-qnpi2gu',
    contents="幫我寫一首和 AI 有關的詩"
)
print(response.text)