import pandas as pd
from konlpy.tag import Kkma

# 증상 문자열 입력 받으면 예측된 질병 번호 중 top3 반환
# 예시: ["목이 아픔", "추움", "기침이 나옴", "콧물이 나옴"] -> [3, 21, 5]
def predict_disease_by_tfidf(symptoms):
    vectorized_data = pd.read_csv('vectorized_data.csv', encoding='CP949')

    token_set = set()
    for symptom in symptoms:
        result = tokenizer(symptom)
        token_set.update(result)

    token_set = [token for token in token_set if token in vectorized_data.columns]
    vectorized_data = vectorized_data[token_set]
    total_sum = vectorized_data.sum(axis=1)
    largest_index = list(total_sum.nlargest(n=3).index)

    return [idx+1 for idx in largest_index]

# 토큰화 해주는 함수
def tokenizer(raw_text):
    # 토큰화 할 단어 태그 http://kkma.snu.ac.kr/documents/?doc=postag
    # (체언, 용언, [관형사, 부사], 어근)
    filter_tag = ('N', 'V', 'M', 'XR')
    kkma = Kkma()
    tokens = kkma.pos(raw_text)
    tokens = [word for word, tag in tokens if (len(word) > 1) and (tag.startswith(filter_tag))]
    return tokens


print("predict start")
symptoms = ["머리가 아픔", "기침이 나오고 두통이 있음"]
result = predict_disease_by_tfidf(symptoms)
print(result)
