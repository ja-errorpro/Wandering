import googlemaps
import requests
import math
import os

API_KEY = "AIzaSyAUBEI-N5zgzAmFbDcyoU-gdPiiPmuw-i8"

def calculate_bearing(lat1, lon1, lat2, lon2):
    """
    計算兩個經緯度點之間的方位角。
    """
    lat1 = math.radians(lat1)
    lon1 = math.radians(lon1)
    lat2 = math.radians(lat2)
    lon2 = math.radians(lon2)

    d_lon = lon2 - lon1
    x = math.sin(d_lon) * math.cos(lat2)
    y = math.cos(lat1) * math.sin(lat2) - (
        math.sin(lat1) * math.cos(lat2) * math.cos(d_lon)
    )
    bearing_rad = math.atan2(x, y)
    bearing_deg = math.degrees(bearing_rad)
    return (bearing_deg + 360) % 3 # 將方位角轉換到 0-360 度範圍內

def get_street_view(location, target_lat, target_lon, size="600x400", pitch=0, fov=90, filename="street_view.jpg", radius=50, source='default'):
    """
    抓取指定位置的街景圖並儲存到檔案，並計算朝向目標位置的角度。
    """
    gmaps = googlemaps.Client(key=API_KEY)
    # 取得街景圖位置的經緯度
    try:
        geocode_result = gmaps.geocode(address=location)
        if geocode_result:
            street_view_lat = geocode_result[0]['geometry']['location']['lat']
            street_view_lon = geocode_result[0]['geometry']['location']['lng']
        else:
            print(f"找不到地點：{location}")
            return

    except googlemaps.exceptions.ApiError as e:
        print(f"Geocoding API 發生錯誤：{e}")
        return

    # 計算方位角
    heading = calculate_bearing(street_view_lat, street_view_lon, target_lat, target_lon)
    print(f"計算出的方位角為：{heading:.2f} 度")

    url = "https://maps.googleapis.com/maps/api/streetview"
    params = {
        "key": API_KEY,
        "location": location,
        "size": size,
        "heading": heading,
        "pitch": pitch,
        "fov": fov,
        "radius": radius,
        "source": source,
    }
    try:
        response = requests.get(url, params=params)
        response.raise_for_status() 

        with open(filename, "wb") as f:
            f.write(response.content)
        print(f"街景圖已成功儲存到 {filename}")

    except requests.exceptions.RequestException as e:
        print(f"抓取街景圖時發生錯誤：{e}")

if __name__ == "__main__":

    location = "100台灣台北市中正區南海路49號"
    target_lat = 25.0315698  # 緯度
    target_lon = 121.5111994  # 經度
    get_street_view(location, target_lat, target_lon, size="1280x720", radius=10, pitch=10)