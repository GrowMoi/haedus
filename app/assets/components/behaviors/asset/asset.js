var AssetBehavior = AssetBehavior || {};
AssetBehavior.assetPath = function(logicalPath) {
  return window.assets[logicalPath];
};
