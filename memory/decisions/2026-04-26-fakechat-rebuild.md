# 决策: FakeChat SOP 重建决定

> 日期: 2026-04-26
> 标签: fakechat, sop, rebuild

## 背景
FakeChat 项目严重违反 SOP-iOS-AppStore-Launch.md，需要全面重建。

## 发现的问题
- 图标方案从未提交审核
- UI设计方案从未提交审核
- AppStore/Assets/Icon/ 和 UI/ 目录缺失
- 项目结构不符合标准
- project.yml 配置错误
- AppIcon Contents.json 格式不符合规范

## 决定
1. 按照 SOP 标准重建 FakeChat 项目
2. 先完成图标和 UI 设计审核，才能继续开发
3. 必须遵循 SOP-iOS-AppStore-Launch.md 的所有规范

## 执行状态
✅ 已记录于 projects/fakechat.md
✅ 已更新 INDEX.md

## 相关文件
- MEMORY.md 行动准则
- SOP-iOS-AppStore-Launch.md