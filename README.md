# 4d-example-reranker

Sample project to test AI Kit rerank support

[`XLM-RoBERTa`](https://huggingface.co/docs/transformers/model_doc/xlm-roberta) seems to have the widest support. `llama.cpp` seems to default to `XLM-RoBERTa` making [`BERT`](https://huggingface.co/docs/transformers/model_doc/bert) reranking incorrect. `int8` quantisation is normally preferred on a CPU but for BERT models it might be necessary to use `float16` for precision.

### Compatibility

Some reranker models are fine tuned causal LLMs; you prompt the AI to rate a set of passages based on thier relevance to a query. The prompt does not follow the user/assistant configuration, which means you must send it to the `/completion` endpoint, not the `chat/completion` endpoint. In any case, these models are no compatible with the `/rerank` endpoint.

```json
{
  "prompt": "Predict if the following passage is relevant to the query: What is the capital of France?\nPassage: Paris is the capital and most populous city of France.\nOutput:",
  "n_predict": 1,
  "temperature": 0.0,
  "top_k": 1,
  "top_p": 1.0,
  "stream": false
}
```

- [`BAAI/bge-reranker-v2-gemma`](https://huggingface.co/BAAI/bge-reranker-v2-gemma)

---

Some reranker models are repurposed causal LLMs; they process token IDs and output logits like an encoder, but the internal architechture is based on a decoder model. These models have a large context window compared to a classic encoder and tend to capture subtle nuances, but the size is large and the inference is computationally expensive.

- [`Qwen/Qwen3-Reranker-0.6B`](https://github.com/miyako/4d-example-reranker/blob/main/README.md#qwenqwen3-reranker-06b)

---

Bigger does not necessarily mean better. The additional layers and parameters of a large model probably creates weights that exceeds the dynamic range of `f16` or `bf16`. Quantised "large" models often generate invalid result. It is normally better to use the "base" model.

- [`mixedbread-ai/mxbai-rerank-large-v1`](https://github.com/miyako/4d-example-reranker/edit/main/README.md#mixedbread-aimxbai-rerank-large-v1)

---

`llama.cpp` supports both `XLM-RoBERTa` and LLM (qwen) rerankers but not BERT rerankers.

- [`amberoad/bert-multilingual-passage-reranking-msmarco`](https://github.com/miyako/4d-example-reranker#amberoadbert-multilingual-passage-reranking-msmarco)
- [`cross-encoder/ms-marco-MiniLM-L6-v2`](https://github.com/miyako/4d-example-reranker?tab=readme-ov-file#cross-encoderms-marco-minilm-l6-v2)

---

`DeBERTa-v2` rerankers significantly deteriorate when quantised using `int8`. 

- [`ibm-granite/granite-embedding-reranker-english-r2`](https://github.com/miyako/4d-example-reranker/blob/main/README.md#ibm-granitegranite-embedding-reranker-english-r2)
- [`mixedbread-ai/mxbai-rerank-xsmall-v1`](https://github.com/miyako/4d-example-reranker/blob/main/README.md#mixedbread-aimxbai-rerank-xsmall-v1)

---

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
`XLM-RoBERTa`

||GGUF Q8_0|ONNX Int8|CTranslate Int8
|-|-|-|-
|`0`|`0.99975650378508`|`0.99979907274246`|`0.99974030256271`|
|`3`|`0.0040334316733283`|`0.0034260561224073`|`0.0037298486568034`|
|`2`|`0.00001605949705307`|`0.00001626304583624`|`0.00001607972626516`|

 [`zenlm/zen3-reranker`](https://huggingface.co/zenlm/zen3-reranker)

---

### 🥈 [BAAI/bge-reranker-large](https://huggingface.co/BAAI/bge-reranker-large)
`XLM-RoBERTa`

||GGUF Q8_0|ONNX Int8|CTranslate Int8| 
|-|-|-|-
|`0`|`0.99963819980621`|`0.99949955940247`|`0.99963819980621`|
|`3`|`0.069412730634212`|`0.05670153722167`|`0.069412730634212`|
|`2`|`0.00007634641951881`|`0.00007670062768739`|`0.00007634641951881`|

 [`zenlm/zen3-reranker-medium`](https://huggingface.co/zenlm/zen3-reranker-medium)

---

### 🥉 [cross-encoder/mmarco-mMiniLMv2-L12-H384-v1](https://huggingface.co/cross-encoder/mmarco-mMiniLMv2-L12-H384-v1)
`XLM-RoBERTa`

||GGUF Q8_0|ONNX Int8|CTranslate Int8| 
|-|-|-|-
|`0`|`0.99997075413285`|`0.99991273880005`|`0.99996781349182`|
|`3`|`0.021881894500755`|`0.020335288718343`|`0.02367801591754`|
|`2`|`0.0037152149705926`|`0.0090650934726`|`0.0035643121227622`|

---

### 🥉 [BAAI/bge-reranker-base](https://huggingface.co/BAAI/bge-reranker-base)
`XLM-RoBERTa`

||GGUF Q8_0|ONNX Int8|CTranslate Int8
|-|-|-|-
|`0`|`0.99974032333812`|`0.99875009059906`|`0.99971753358841`|
|`3`|`0.00003758999629534`⤴|`0.00003786411252804`⤴|`0.00003765087967622`⤴|
|`2`|`0.00035163012593452`⤵|`0.00016138107457664`⤵|`0.00032641555299051`⤵|

[`zenlm/zen3-reranker-small`](https://huggingface.co/zenlm/zen3-reranker-small)

---

### 🥉 [Qwen/Qwen3-Reranker-0.6B](https://huggingface.co/Qwen/Qwen3-Reranker-0.6B)
`Qwen3`

||GGUF Q8_0|ONNX Int8|
|-|-|-|
|`0`|`0.99849343299866`|`0.11751576513052`||
|`3`|`0.17696142196655`|`0.090718969702721`|
|`2`|`0.00014215805276763`|`0.080813035368919`||

---

### 🥉 [jinaai/jina-reranker-v2-base-multilingual](https://huggingface.co/jinaai/jina-reranker-v2-base-multilingual)
`XLM-RoBERTa` with [`flash attention`](https://huggingface.co/jinaai/xlm-roberta-flash-implementation-onnx)

||GGUF Q8_0|ONNX Int8|
|-|-|-|
|`0`|`0.91580612478166`|`0.9150967001915`||
|`3`|`0.19414707725`|`0.19158935546875`||
|`2`||||

---

### 🥉 [amberoad/bert-multilingual-passage-reranking-msmarco](https://huggingface.co/amberoad/bert-multilingual-passage-reranking-msmarco)
`BERT`

||GGUF Q8_0|ONNX F16|ONNX Int8|CTranslate Int8
|-|-|-|-|-
|`0`||`0.99972993135452`|`0.99938893318176`|`0.9980161190033`|
|`3`||`0.00001711601180432`|`0.00001833355418057`|`0.0012083178153262`|
|`2`||`0.00001573694680701`|`0.00014862575335428`|`0.0004223593568895`|

---

### [Qwen/Qwen3-Reranker-4B](https://huggingface.co/Qwen/Qwen3-Reranker-4B)
`Qwen3`

> [!WARNING]
> ONNX scores are mushed.

||GGUF Q8_0|GGUF Q4_K_M|ONNX Int8|
|-|-|-|-|
|`0`|`0.99664956331253`|`0.99508684873581`|`0.89622062444687`||
|`3`|`0.78410738706589`|`0.74128645658493`||
|`2`|`0.00003427601041039`|`0.00001430954580428`|`0.73410618305206`⤴||

---

### [ContextualAI/ctxl-rerank-v2-instruct-multilingual-1b](https://huggingface.co/ContextualAI/ctxl-rerank-v2-instruct-multilingual-1b)
`Qwen3`

> [!WARNING]
> ONNX scores are mushed.

||GGUF Q8_0|GGUF Q4_K_M|ONNX Int8|
|-|-|-|-|
|`0`|`9.4151462651145E-30`|`2.0864364569468E-30`|`0.60062056779861`||
|`3`|`8.8091215631413E-30`|`5.9291352010278E-31`|`0.50628370046616`⤵|
|`2`|`4.313235214862E-30`|`4.2437697053386E-31`|||

---

### [cross-encoder/ms-marco-MiniLM-L6-v2](https://huggingface.co/cross-encoder/ms-marco-MiniLM-L6-v2)
`BERT`

> [!WARNING]
> llama.cpp scores are mushed.
 
||GGUF F16|GGUF Q8_0|ONNX F16|ONNX Int8|CTranslate Int8
|-|-|-|-|-|-
|`0`|`0.4982936187771`|`0.4982936187771`|`0.99997842311859`|`0.99997627735138`|`1`|
|`3`|`0.48758885823757`|`0.48758885823757`|`0.00002105345265591`|`0.00002080343438138`|`0.0000000004588505964076`|
|`2`|`0.48588368773412`|`0.48588368773412`|`0.00001613207132323`|||

---

### [maidalun1020/bce-reranker-base_v1](https://huggingface.co/maidalun1020/bce-reranker-base_v1)
`XLM-RoBERTa`

> [!WARNING]
> Scores are mushed.

||GGUF Q8_0|ONNX Int8|CTranslate Int8
|-|-|-|-
|`0`|`0.66729423323589`|`0.69750744104385`|`0.82112324237823`|
|`3`|`0.43259480279184`|`0.43118476867676`|`0.62696254253387`|
|`2`|`0.38427266104648`|`0.38333082199097`|`0.52052652835846`|

---

### [jinaai/jina-reranker-v1-turbo-en](https://huggingface.co/jinaai/jina-reranker-v1-turbo-en)
`BERT`

> [!WARNING]
> Scores are mushed.

||GGUF Q8_0|ONNX Int8|CTranslate Int8
|-|-|-|-
|`0`|`0.47711632548651`|`0.26465171575546`⤵||
|`3`|`0.47559809684731`⤴|`0.27939757704735`⤵||
|`2`|`0.47688768439384`⤵||

---

### [ibm-granite/granite-embedding-reranker-english-r2](https://huggingface.co/ibm-granite/granite-embedding-reranker-english-r2)
`ModernBERT`

> [!WARNING]
> Integer scores are low in precision.
 
||GGUF Q8_0|ONNX F16|ONNX Int8|
|-|-|-|-|
|`0`||`0.91985809803009`|`0.79878783226013`||
|`3`||`0.078764326870441`|`0.67189735174179`||
|`2`|||`0.47672122716904`||

---

### [mixedbread-ai/mxbai-rerank-xsmall-v1](https://huggingface.co/mixedbread-ai/mxbai-rerank-xsmall-v1)
`DeBERTa-v2`

> [!WARNING]
> Integer scores are low in precision.

||ONNX F16|ONNX Int8|
|-|-|-|debert
|`0`|`0.91985809803009`|`0.76543623209`||
|`3`|`0.078764326870441`|`0.11033684015274`⤵||
|`2`||||

---

### [mixedbread-ai/-rerank-base-v1](https://huggingface.co/mixedbread-ai/mxbai-rerank-base-v1)
`DeBERTa-v2`

> [!WARNING]
> Integer scores are low in precision.

||ONNX F16|ONNX Int8|
|-|-|-
|`0`|`0.94747817516327`|`0.23237489163876`||
|`3`|`0.25853633880615`|`0.19631579518318`||
|`2`|`0.0044187577441335`|||

---

### [mixedbread-ai/mxbai-rerank-large-v1](https://huggingface.co/mixedbread-ai/mxbai-rerank-large-v1)
`DeBERTa-v2`

> [!WARNING]
> The model might have collapsed under its own weight. 

||ONNX F16|ONNX Int8|
|-|-|-|
|`0`|`0.050157018005848`⤵||
|`3`|
|`2`|`0.071954950690269`⤴||

---

### [jinaai/jina-reranker-v3](https://huggingface.co/jinaai/jina-reranker-v3)
`Qwen3`

> [!WARNING]
> The scores in llama.cpp are off but the model works well on [Jina AI](https://jina.ai/reranker/).

||GGUF Q8_0|ONNX Int8|
|-|-|-|
|`0`|`0.75106662511826`|||
|`3`||||
|`2`|`0.24428156018257`|||

---

### [zeroentropy/zerank-1-small](https://huggingface.co/zeroentropy/zerank-1-small)
`Qwen3`

> [!WARNING]
> The scores are off.

||GGUF Q8_0|ONNX Int8|
|-|-|-|
|`0`|`3.272465469603e-17`⤵|`0.96800327301025`⤵||
|`3`|`7.827476960511e-18`⤵|`0.94187527894974`⤵||
|`2`||||
