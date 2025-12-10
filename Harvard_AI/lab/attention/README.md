⚠ TF 版 BERT 已经“半停止支持”，新版 Transformers 不再兼容。

HuggingFace 在 从 PyTorch checkpoint 加载到 TF 模型时失败
（因为 v4.40+ 的 safetensors 加载器改了 API，而 TF 的加载逻辑已经不再维护）。

---

✅ 最简单、100% 能跑通 CS50 Lab 的解决方案：降级 Transformers

```bash
conda create -n tf310 python=3.10 -y
conda activate tf310
pip install tensorflow==2.15.0
pip install "transformers==4.35.0"
pip install -r requirements.txt
```

接着运行 `python mask.py` 即可。
