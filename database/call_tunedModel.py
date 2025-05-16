import time
from google import genai
from google.genai import types


API_KEY = "Vertex_API_Key"
client = genai.Client(api_key=API_KEY)

response = client.models.generate_content(
    model='tunedModels/travelrecommendationmodelfromcsv-3n5xa71',
    contents="偏好自然景觀，請推薦我旅遊行程。",
)
print(response.text)