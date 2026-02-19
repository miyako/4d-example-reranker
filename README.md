# 4d-example-reranker

Sample project to test AI Kit rerank support

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
|`0`|`0.99975650378508`|`0.9982253909111`|`0.99974030256271`|
|`3`|`0.0040334316733283`|`0.012791481800377`|`0.0037298486568034`|
|`2`|`0.00001605949705307`|`0.00007260562415468`|`0.00001607972626516`|

### 🥈 [BAAI/bge-reranker-base](https://huggingface.co/BAAI/bge-reranker-base)

||GGUF Q8_0|ONNX Int8|CTranslate Int8
|-|-|-|-
|`0`|``|`0.9995738863945`|`0.99971753358841`|
|`3`|``|`0.00095846987096593`|`0.00032641555299051`|
|`2`|``|`0.00027665623929352`|`0.00003765087967622`|

### Model: [cross-encoder/mmarco-mMiniLMv2-L12-H384-v1](https://huggingface.co/cross-encoder/mmarco-mMiniLMv2-L12-H384-v1)

||GGUF Q8_0|ONNX Int8|CTranslate Int8| 
|-|-|-|-
|`0`|`0.99997075413285`|`0.97348910570145`|`0.99996781349182`|
|`3`|`0.021881894500755`|`0.027220340445638`|`0.02367801591754`|
|`2`|`0.0037152149705926`|`0.010983953252435`|`0.0035643121227622`|

### Model: [BAAI/bge-reranker-large](https://huggingface.co/BAAI/bge-reranker-large)

||GGUF Q8_0|ONNX Int8|CTranslate Int8| 
|-|-|-|-
|`0`|``|⚠️|`0.99963819980621`|
|`3`|``|⚠️|`0.069412730634212`|
|`2`|``|⚠️|`0.00007634641951881`|

### ⚠️ [cross-encoder/ms-marco-MiniLM-L6-v2](https://huggingface.co/cross-encoder/ms-marco-MiniLM-L6-v2)

||GGUF Q8_0|ONNX Int8|CTranslate Int8
|-|-|-|-
|`0`|``|`0.3249731361866`|`0.4925831258297`|
|`2`|``|`0.012862857431173`|`0.48784512281418`|
|`3`|``|`0.0076748430728912`|`0.48617944121361`|

---

<img width="500" height="auto" alt="" src="https://github.com/user-attachments/assets/93b8461d-a892-49fd-bf5c-ef2158a2a4f3" />
