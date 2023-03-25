import requests
from bs4 import BeautifulSoup
from selenium import webdriver
from selenium.webdriver.common.by import By
import re
import pandas as pd


# 특정 위치의 질병 정보 출력하기
def print_disease(loc):
    print('--name--\n' + disease_data['name'][loc] + '\n')
    print('--symptom_sum--\n' + disease_data['symptom_sum'][loc] + '\n')
    print('--related_disease--\n' + disease_data['related_disease'][loc] + '\n')
    print('--medical_department--\n' + disease_data['medical_department'][loc] + '\n')
    print('--synonym--\n' + disease_data['synonym'][loc] + '\n')
    print('--definition--\n' + disease_data['definition'][loc] + '\n')
    print('--cause--\n' + disease_data['cause'][loc] + '\n')
    print('--symptom--\n' + disease_data['symptom'][loc] + '\n')
    print('--diagnosis--\n' + disease_data['diagnosis'][loc] + '\n')
    print('--cure--\n' + disease_data['cure'][loc] + '\n')

# 웹크롤링하기
def web_crawling(disease_data):
    # 서울아산병원 질환백과
    url = "https://www.amc.seoul.kr/asan/healthinfo/disease/diseaseList.do?searchKeyword="
    driver = webdriver.Chrome()
    driver.get(url)

    # 전체 페이지가 얼마나 되는지 확인
    html = requests.get(url).text
    soup = BeautifulSoup(html, 'html.parser')
    last_page = soup.find('a', class_='lastPageBtn')
    last_page = int(re.findall('[0-9]+', str(last_page))[0])

    # 웹 크롤링 시작
    cnt = 0
    for page in range(last_page):

        # 해당 페이지 안에 있는 질병 목록 확인
        diseases = driver.find_elements(By.CLASS_NAME, 'contTitle')

        # 각 질병 설명을 보기 위해 순회하면서 클릭
        for disease in diseases:
            print('\rwebcrawling: ' + str(cnt), end='')
            cnt += 1
            disease.find_element(By.TAG_NAME, 'a').click()

            # 정보 추출
            html = driver.page_source
            soup = BeautifulSoup(html, 'html.parser')

            # 1. name
            cont_title = soup.find('strong', class_='contTitle').text.strip()

            # 2. symptom_sum, related_disease_sum, medical_department_sum
            cont_box_title = soup.find('div', class_='contBox').find('dl').find_all('dt')
            cont_box_content = soup.find('div', class_='contBox').find('dl').find_all('dd')

            symptom_sum, related_disease, medical_department, synonym = '', '', '', ''
            for idx, title in enumerate(cont_box_title):
                if title.text == '증상':
                    symptom_sum = ', '.join([x.text for x in cont_box_content[idx].find_all('a')])
                elif title.text == '관련질환':
                    related_disease = ', '.join([x.text for x in cont_box_content[idx].find_all('a')])
                elif title.text == '진료과':
                    medical_department = ', '.join([x.text for x in cont_box_content[idx].find_all('a')])
                elif title.text == '동의어':
                    synonym = re.sub('\n|\xa0', '', cont_box_content[idx].text).strip()

            # 3. definition, cause, symptom, diagnosis, cure
            cont_description_title = soup.find('div', class_='contDescription').find('dl').find_all('dt')
            cont_description_content = soup.find('div', class_='contDescription').find('dl').find_all('dd')

            definition, cause, symptom, diagnosis, cure = '', '', '', '', ''
            for idx, title in enumerate(cont_description_title):
                if title.text == '정의':
                    definition = re.sub('\n|\xa0', '', cont_description_content[idx].text).strip()
                elif title.text == '원인':
                    cause = re.sub('\n|\xa0', '', cont_description_content[idx].text).strip()
                elif title.text == '증상':
                    symptom = re.sub('\n|\xa0', '', cont_description_content[idx].text).strip()
                elif title.text == '진단':
                    diagnosis = re.sub('\n|\xa0', '', cont_description_content[idx].text).strip()
                elif title.text == '치료':
                    cure = re.sub('\n|\xa0', '', cont_description_content[idx].text).strip()

            # 정보 추가
            disease_data.loc[len(disease_data)] = [cont_title, symptom_sum, related_disease, medical_department, synonym,
                                                   definition, cause, symptom, diagnosis, cure]

            # 뒤로 가기
            driver.back()

        # 페이지 이동
        if page != last_page - 1:
            driver.find_element(By.CLASS_NAME, 'nextPageBtn').click()


# 데이터 형식 정의
disease_data = pd.DataFrame(
    columns=[
        'name',                 # 질병명
        'symptom_sum',          # 증상(요약)
        'related_disease',      # 관련 질환
        'medical_department',   # 진료과
        'synonym',              # 동의어
        'definition',           # 정의
        'cause',                # 원인
        'symptom',              # 증상
        'diagnosis',            # 진단
        'cure'                  # 치료
    ]
)

web_crawling(disease_data)
disease_data.to_xml('disease_data.xml')

