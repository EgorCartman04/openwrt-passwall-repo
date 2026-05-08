# openwrt-passwall-repo

Публичный репозиторий для хранения артефактов сборки OpenWrt Passwall.

Что хранится в этом репозитории:

- release-aware feed в ветке `gh-pages`;
- архивы feed в GitHub Releases;
- sysupgrade-образы и сопутствующие файлы в GitHub Releases;
- workflow и helper-скрипты для повторяемой пересборки.

Основные workflow:

- `.github/workflows/build-openwrt-passwall-feed.yml`
- `.github/workflows/build-openwrt-sysupgrade.yml`

Feed публикуется по пути:

`https://<owner>.github.io/openwrt-passwall-repo/feeds/passwall2/<release>/<target>/<subtarget>/`
