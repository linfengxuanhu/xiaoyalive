# Xiaoya Live V0.1

小雅实时数字人过渡项目：离线全屏肖像展示、轻微呼吸/浮动动效、待机/倾听/说话演示状态。

## 当前版本边界

- 不接入 AI、大模型、麦克风、语音识别或语音合成。
- 当前“倾听/说话”是手动演示状态，不代表真实音频识别。
- 当前人物微动是整体画面轻微缩放和位移，不是真正的面部驱动动画；眨眼、头部独立运动和音频口型将在后续版本实现。
- 肖像素材为本项目生成的概念素材，后续可以替换为干净的角色原图或动画素材。

## 本地运行

```bash
flutter pub get
flutter analyze
flutter run
```

## GitHub Actions

将整个目录上传到 GitHub 仓库根目录，进入 Actions，运行 `Build Xiaoya Live APK`。成功后在 Artifacts 下载 `xiaoya-live-v0.1-apk`。
