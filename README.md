# 4d-example-renranker

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

### Model: [BAAI/bge-reranker-v2-m3](https://huggingface.co/BAAI/bge-reranker-v2-m3)

||GGUF Q8_0|ONNX Int8|CTranslate Int8|Text Embedding Inference 
|-|-|-|-|-
|`0`|`0.99975650378508`|`0.9982253909111`|`0.99974030256271`|
|`3`|`0.0040334316733283`|`0.012791481800377`|`0.0037298486568034`|
|`2`|`0.00001605949705307`|`0.00007260562415468`|`0.00001607972626516`|

<img width="800" height="auto" alt="" src="https://github.com/user-attachments/assets/93b8461d-a892-49fd-bf5c-ef2158a2a4f3" />
