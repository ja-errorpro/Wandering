import googlemaps
import time
import csv
from collections import deque
import json

API_KEY = "AIzaSyAUBEI-N5zgzAmFbDcyoU-gdPiiPmuw-i8"

INITIAL_LOCATION = (25.047924, 121.517081) # 台北車站
RADIUS = 10000
PLACE_TYPE = "tourist_attraction"
LANGUAGE = "zh-TW"
MAX_RESULTS = 1000
OUTPUT_FILE = "taiwan_attractions.csv"

def get_places_in_radius(location, radius, place_type, api_key, language):
    """
    抓取指定區域內的景點資料
    """
    gmaps = googlemaps.Client(key=api_key)
    time.sleep(2)
    places_result = gmaps.places_nearby(location=location, radius=radius, type=place_type, language=language)
    return places_result['results'], places_result.get('next_page_token')

def save_to_csv(data, filename=OUTPUT_FILE):
    """
    將景點資料儲存到 CSV 檔案
    """
    try:
        with open(filename, "w", encoding="utf-8", newline="") as f:
            writer = csv.writer(f)
            # 寫入標題列
            writer.writerow([
                "place_id", "name", "address", "lat", "lng", "rating", "details",
                "search_location", "search_radius"
            ])

            for place in data:
                # 取得地點詳細資料
                time.sleep(2)  # 避免 API 請求過快
                gmaps = googlemaps.Client(key=API_KEY)  # 確保你有 API_KEY
                place_details = gmaps.place(place_id=place['place_id'], language=LANGUAGE)
                if place_details and place_details['result']:
                    details = place_details['result']
                    latitude = details['geometry']['location']['lat']
                    longitude = details['geometry']['location']['lng']
                    rating = details.get('rating', None)
                    details_json = json.dumps(details, ensure_ascii=False)
                else:
                    latitude = None
                    longitude = None
                    rating = None
                    details_json = None
                #  search_location, search_radius 從 place 提取
                search_location = place.get('search_location')
                search_radius = place.get('search_radius')
                # 寫入資料列
                writer.writerow([
                    place['place_id'],
                    place['name'],
                    place['vicinity'],
                    latitude,
                    longitude,
                    rating,
                    details_json,
                    search_location,
                    search_radius
                ])
        print(f"資料已成功儲存到 {filename}")
    except Exception as e:
        print(f"儲存到 CSV 時發生錯誤：{e}")

def expand_search(initial_location, radius, place_type, api_key, language):
    """
    從每個景點向外擴展搜索
    """
    found_places = []
    visited_locations = set()
    search_queue = deque([(initial_location, initial_location, radius)])

    while search_queue and len(found_places) < MAX_RESULTS:
        location, original_location, original_radius = search_queue.popleft()

        places, next_page_token = get_places_in_radius(location, radius, place_type, api_key, language)
        if not places:
            print(f"在 {location} 半徑 {radius} 內找不到景點")
            continue

        for place in places:
            location_str = place['vicinity']
            if location_str in visited_locations:
                continue
            place['search_location'] = original_location
            place['search_radius'] = original_radius
            found_places.append(place)
            visited_locations.add(location_str)
            if len(found_places) >= MAX_RESULTS:
                break

            search_queue.append(
                (
                    (place['geometry']['location']['lat'], place['geometry']['location']['lng']),
                    original_location,
                    original_radius
                )
            )

        if len(found_places) >= MAX_RESULTS:
            break

    print(f"總共找到 {len(found_places)} 個景點。")
    save_to_csv(found_places) # 使用 save_to_csv 儲存資料

if __name__ == "__main__":
    expand_search(INITIAL_LOCATION, RADIUS, PLACE_TYPE, API_KEY, LANGUAGE)
