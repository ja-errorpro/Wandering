import googlemaps
import time
import csv
from collections import deque
import json

API_KEY = "AIzaSyAUBEI-N5zgzAmFbDcyoU-gdPiiPmuw-i8"
INITIAL_LOCATION = [
                    ("Keelung North Railway Station", "25.134274343711827, 121.74005245320404"), # 基隆北站
                    ("Qi Du Railway Station", "25.09468489648192, 121.7127353316717"),  # 七堵車站
                    ("Banqiao Railway Station", "25.014196157791464, 121.46380554247673"), # 板橋車站
                    ("Shulin Railway Station", "24.991224628773146, 121.42488153989889"), # 樹林車站
                    ("Ruifang Railway Station", "25.10882632614538, 121.80596281436307"), # 瑞芳車站
                    ("Nangang Railway Station", "25.05326442718221, 121.60700774062991"), # 南港車站
                    ("Songshan Railway Station", "25.049369808852937, 121.57825488420708"), # 松山車站
                    ("Taipei Main Station", "25.04754417535744, 121.51729039749631"),  #台北車站
                    ("Wanhua Railway Station", "25.03343177648604, 121.50036814247721"), # 萬華車站
                    ("Taoyuan Railway Station", "24.989085294212295, 121.31449364062816"), # 桃園車站
                    ("Zhongli Railway Station", "24.95377498709887, 121.2260759940431"), # 中壢車站
                    ("Hsinchu Railway Station", "24.801762984627317, 120.97164194062309"), # 新竹車站
                    ("Zhunan Railway Station", "24.686764446943904, 120.88091674801105"), # 竹南車站
                    ("Miaoli Railway Station", "24.5701760960207, 120.82272923451403"), # 苗栗車站
                    ("Fengyuan Railway Station", "24.25433860549813, 120.72386783450546"), # 豐原車站
                    ("Taichung Railway Station", "24.13799179416188, 120.69001556678998"), # 台中車站
                    ("Changhua Railway Station", "24.081770504061218, 120.53891433819653"), # 彰化車站
                    ("Yuanlin Railway Station", "23.95944563962951, 120.5700433363456"), # 員林車站
                    ("Douliu Railway Station", "23.71209312112982, 120.54088173689814"), # 斗六車站
                    ("Chiayi Railway Station", "23.479366532718625, 120.44116028873985"), # 嘉義車站
                    ("Xinying Railway Station", "23.30691479263617, 120.32333098845577"), # 新營車站
                    ("Tainan Railway Station", "22.997293478277427, 120.21336943447264"), # 台南車站
                    ("Okayama Train Station", "22.792388672149162, 120.3005671669982"), # 岡山車站
                    ("Xinzuoying Railway Station", "22.68898138339625, 120.30843314053197"), # 新左營車站
                    ("Kaohsiung Railway Station", "22.63968051963547, 120.30295850562814"), # 高雄車站
                    ("Pingtung Railway Station", "22.66906577932277, 120.48645913446433"), # 屏東車站
                    ("Chaozhou Railway Station", "22.550186747858906, 120.53660672863839"), # 潮州車站
                    ("Taitung Railway Station", "22.794093753146733, 121.1234566191258"), # 台東車站
                    ("Yuli Railway Station", "23.331677603167147, 121.31212769215196"), # 玉里車站
                    ("Hualien Railway Station", "23.99345050338126, 121.60163173449853"), # 花蓮車站
                    ("Su'ao New Railway Station", "24.609203021467092, 121.82880932713128"), # 蘇澳新車站
                    ("Yilan Railway Station", "24.755448164274277, 121.75876800753154") # 宜蘭車站
                    ]
RADIUS = 10000
PLACE_TYPE = "tourist_attraction"
LANGUAGE = "zh-TW"
MAX_RESULTS = 1000
OUTPUT_FILE = "_attractions_1000.csv"

def get_places_in_radius(location, radius, place_type, api_key, language):
    """
    抓取指定區域內的景點資料
    """
    gmaps = googlemaps.Client(key=api_key)
    time.sleep(1)
    places_result = gmaps.places_nearby(location=location, radius=radius, type=place_type, language=language)
    return places_result['results'], places_result.get('next_page_token')

def save_to_csv(data, filename):
    """
    將景點資料儲存到 CSV 檔案
    """
    try:
        with open(filename, "w", encoding="utf-8", newline="") as f:
            writer = csv.writer(f)
            # 寫入標題列
            writer.writerow([
                "place_id", "name", "address", "lat", "lng", "rating", "details"
            ])

            for place in data:
                # 取得地點詳細資料
                time.sleep(1)  # 避免 API 請求過快
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
                # 寫入資料列
                writer.writerow([
                    place['place_id'],
                    place['name'],
                    place['vicinity'],
                    latitude,
                    longitude,
                    rating,
                    details_json
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
    search_queue = deque([(initial_location[1], initial_location[1], radius)])

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
    save_to_csv(found_places, initial_location[0] + OUTPUT_FILE) # 使用 save_to_csv 儲存資料

if __name__ == "__main__":
    for location in INITIAL_LOCATION:
        expand_search(location, RADIUS, PLACE_TYPE, API_KEY, LANGUAGE)
