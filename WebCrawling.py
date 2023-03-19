import requests
from bs4 import BeautifulSoup
import selenium
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
import re
from time import sleep

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
for page in range(last_page):

    # 해당 페이지 안에 있는 질병 목록 확인
    diseases = driver.find_elements(By.CLASS_NAME, 'contTitle')

    # 각 질병 설명을 보기 위해 순회하면서 클릭
    for disease in diseases:
        disease.find_element(By.TAG_NAME, 'a').click()

        # 정보 추출 (구현 예정)
        html = driver.page_source
        soup = BeautifulSoup(html, 'html.parser')
        sleep(2)

        driver.back()

    # 페이지 이동
    if page != last_page-1:
        driver.find_element(By.CLASS_NAME, 'nextPageBtn').click()