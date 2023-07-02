import pandas as pd
import numpy as np
from konlpy.tag import Kkma
from sklearn.feature_extraction.text import TfidfVectorizer


# 토큰화 해주는 함수
def tokenizer(raw_text):
    # 토큰화 할 단어 태그 http://kkma.snu.ac.kr/documents/?doc=postag
    # (체언, 용언, [관형사, 부사], 어근)
    filter_tag = ('N', 'V', 'M', 'XR')
    kkma = Kkma()
    tokens = kkma.pos(raw_text)
    tokens = [word for word, tag in tokens if (len(word) > 1) and (tag.startswith(filter_tag))]
    return tokens


# 토큰화 및 벡터화 하기
def tokenize_and_vectorize(data):
    vectorizer = TfidfVectorizer(tokenizer=tokenizer, min_df=1)
    vectorized = vectorizer.fit_transform(data.values.astype('U'))
    return vectorizer, vectorized


# 특정 질병 토큰화 결과 확인해 보기
def print_tokenize_result(data, idx):
    print('=' * 100)
    print("\n문장:", data[idx])
    print("토큰화:", tokenizer(str(data[idx])))
    print('=' * 100, '\n')


# 특정 질병 벡터화 결과 확인해 보기
def print_vectorized_result(vectorized_result, idx):
    np.set_printoptions(precision=1, threshold=np.inf)
    vectorizer, vectorized = vectorized_result
    print('=' * 100)
    print("단어:", sorted(vectorizer.vocabulary_.items()))
    print("tf-idf:", vectorized.toarray()[idx])
    print('=' * 100, '\n')


# 결과를 csv 형식으로 추출하기
def make_dataframe(vectorized_result):
    vectorizer, vectorized = vectorized_result
    words = np.array(sorted(vectorizer.vocabulary_.items()))[:, 0]
    vectorized_data = pd.DataFrame(vectorized.toarray())
    vectorized_data.to_csv('vectorized_data.csv', header=words, encoding='CP949')


disease_data = pd.read_csv('disease_data.csv', encoding='CP949')
result = tokenize_and_vectorize(disease_data['symptom'])

make_dataframe(result)

# 2번째 질병에 대한 예시 출력
print_tokenize_result(disease_data['symptom'], 2)
print_vectorized_result(result, 2)