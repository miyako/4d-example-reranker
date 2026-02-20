# 4d-example-reranker

Sample project to test AI Kit rerank support

[XLM-RoBERTa](https://huggingface.co/docs/transformers/model_doc/xlm-roberta) seems to have the widest support.

## Example

```4d
var $client:=cs.AIKit.Reranker.new({baseURL: "http://127.0.0.1:8080/v1"})

var $query:=cs.AIKit.RerankerQuery.new({query: "What is deep learning?"; documents: [\
"Deep learning is a subset of machine learning based on artificial neural networks."; \
"Apples are red and sweet fruits that grow on trees."; \
"The theory of relativity was developed by Albert Einstein."; \
"Neural networks simulate the human brain to solve complex problems."\
]})

var $parameters:=cs.AIKit.RerankerParameters.new({model: "default"; top_n: 3})

var $result:=$client.rerank.create($query; $parameters)
```

### 🥇 [BAAI/bge-reranker-v2-m3](https://huggingface.co/BAAI/bge-reranker-v2-m3)

||GGUF Q8_0|ONNX Int8|CTranslate Int8
|-|-|-|-
|`0`|`0.99975650378508`|`0.99979907274246`|`0.99974030256271`|
|`3`|`0.0040334316733283`|`0.0034260561224073`|`0.0037298486568034`|
|`2`|`0.00001605949705307`|`0.00001626304583624`|`0.00001607972626516`|

---

### 🥈 [BAAI/bge-reranker-large](https://huggingface.co/BAAI/bge-reranker-large)

||GGUF Q8_0|ONNX Int8|CTranslate Int8| 
|-|-|-|-
|`0`|`0.99963819980621`|`0.99949955940247`|`0.99963819980621`|
|`3`|`0.069412730634212`|`0.05670153722167`|`0.069412730634212`|
|`2`|`0.00007634641951881`|`0.00007670062768739`|`0.00007634641951881`|

---

### 🥉 [cross-encoder/mmarco-mMiniLMv2-L12-H384-v1](https://huggingface.co/cross-encoder/mmarco-mMiniLMv2-L12-H384-v1)

||GGUF Q8_0|ONNX Int8|CTranslate Int8| 
|-|-|-|-
|`0`|`0.99997075413285`|`0.99991273880005`|`0.99996781349182`|
|`3`|`0.021881894500755`|`0.020335288718343`|`0.02367801591754`|
|`2`|`0.0037152149705926`|`0.0090650934726`|`0.0035643121227622`|

---

###  [BAAI/bge-reranker-base](https://huggingface.co/BAAI/bge-reranker-base)

> This model correctly identifies the most relevant document and its general significance but fails to weigh subtle nuances.

||GGUF Q8_0|ONNX Int8|CTranslate Int8
|-|-|-|-
|`0`|`0.99974032333812`|`0.99875009059906`|`0.99971753358841`|
|`3`|`0.00003758999629534`⤴|`0.00003786411252804`⤴|`0.00003765087967622`⤴|
|`2`|`0.00035163012593452`⤵|`0.00016138107457664`⤵|`0.00032641555299051`⤵|

---

### [cross-encoder/ms-marco-MiniLM-L6-v2](https://huggingface.co/cross-encoder/ms-marco-MiniLM-L6-v2)

> This model is BERT, not XLM-RoBERTa. The flat results suggest a bug in BERT reranking (not using token type IDs).

||GGUF Q8_0|ONNX Int8|CTranslate Int8
|-|-|-|-
|`0`|`0.4982936187771`|`0.99997627735138`|`0.4925831258297`|
|`3`|`0.48758885823757`|`0.00002080343438138`|`0.48617944121361`⤴|
|`2`|`0.48588368773412`||`0.48784512281418`⤵

---

### [jinaai/jina-reranker-v1-turbo-en](https://huggingface.co/jinaai/jina-reranker-v1-turbo-en)

> This model seems to have a non standard BERT implementation (`[batch, 1]`).

||GGUF Q8_0|ONNX Int8|CTranslate Int8
|-|-|-|-
|`0`|`0.47711632548651`|`0.26465171575546`⤵||
|`3`|`0.47559809684731`⤴|`0.27939757704735`⤵||
|`2`|`0.47688768439384`⤵||

---

### [ibm-granite/granite-embedding-reranker-english-r2](https://huggingface.co/ibm-granite/granite-embedding-reranker-english-r2)

>  This model is ModernBERT. Export to GGUF is not supported as of February 2026.

||GGUF Q8_0|ONNX Int8|CTranslate Int8
|-|-|-|-
|`0`||`0.79878783226013`||
|`3`||`0.67189735174179`||
|`2`||`0.47672122716904`||

---

### [amberoad/bert-multilingual-passage-reranking-msmarco](https://huggingface.co/amberoad/bert-multilingual-passage-reranking-msmarco)

||GGUF Q8_0|ONNX Int8|CTranslate Int8
|-|-|-|-
|`0`|``|`0.99938893318176`||
|`3`|``|`0.00001833355418057`||
|`2`|``|`0.00014862575335428`||

---


