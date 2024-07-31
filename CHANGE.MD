# Version 0.1.107
 - HYPopupDialog 弹出增加检测context，如果context不再显示状态不再弹出。 合并解决 Bug#2， 需要精确设置context，如果PageA切换到PageB。context不能是全局的，必须是PageA。只要PageA不再显示了问卷就不再弹出
 - HYPopupDialog 增加 close 方法，允许取消关闭。[HYPopupDialog close] 合并解决 Bug#2， 如果无法做到控制context，那么也可以主动调用close方法关闭PopupDialog。
 - 优化SurveyView视图结构解决卡顿问题 优化 Bug#3
 - HYPopupDialog 增加键盘状态布局处理 解决 Bug#3

# Bugs
1、一加GM1900安卓手机的CEM弹窗弹出很慢，需要等6-8秒才出来&这个手机连接代理后CEM弹窗弹不出来
2、重复弹CEM弹窗（弹出问卷前，切换到其他页面，弹窗出现在其他页面，如果其他页面有弹窗就导致弹窗重复出现了）
3、配置固定高度时，ios手机的CEM弹窗滑动不流畅（安卓正常）
4、配置的固定高度，ios手机的CEM问卷输入框被隐藏了（安卓正常）
5、ios手机的CEM动画效果体验不太好，一闪的出来，有些突兀