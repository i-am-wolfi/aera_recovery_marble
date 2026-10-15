# AERA device tree for POCO F5 / Redmi Note 12 Turbo (marble)

AERA Recovery Project device support for Xiaomi `marble` (SM7475 Snapdragon 7+ Gen 2).

- Status: WIP / bring-up. Base validada via dump do aparelho.
- Base: fork lógico de `Ctapchuk/android_device_xiaomi_marble-OFRP` (branch `fox_16.0` / `fox_12.1`) + padrão AERA de `sm84xx-common-AERA` e `dada-AERA`.
- Recovery de referência no aparelho: OrangeFox do Ardjlon (build `fox_marble-eng`, `fox_12.1`, 26-fev-2026) — dump em `~/recovery/recovery_a.img`.

## Dump atual (via adb, slot `_a`, root via KernelSU)

- `recovery_a.img`: 104857600 bytes (100M), Android bootimg header v4, kernel_size=0 (`BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE`), ramdisk LZ4 40M
- sha256: `0ddc89c60d42e2563df6bb293714f2eeec73d11da852274103962fe9fc5b1932`
- Sistema: HyperOS `OS3.0.3.0.VMRMIXM`, Android 15, slot `_a`
- Ramdisk extraído em `~/recovery/ramdisk-extract` (cpio LZ4)

## Touch: causa raiz + fix aplicado nesta tree

- Issue #7 do Ctapchuk só afeta quem trocou kernel stock -> Melt/Glow. Com stock funciona.
- Tree Ctapchuk carrega só `TW_LOAD_VENDOR_MODULES := "adsp_loader_dlkm.ko goodix_core.ko"` e depende do `vendor_dlkm` do sistema.
- Vendor atual (HyperOS 3.0) tem: `atmel_mxt_ts.ko focaltech_fts.ko goodix_3626.ko xiaomi_touch.ko` (sem `goodix_core.ko`).
- Build do Ardjlon que funciona embarca no ramdisk `vendor/lib/modules/hos1/` + `miui14/` (adsp chain + `goodix_core.ko` + `xiaomi_touch.ko`) + firmwares `vendor/firmware/goodix_*`.
- Fix nesta tree (`BoardConfig.mk`): lista completa de módulos touch + chain ADSP (mesmo padrão do `sm84xx-common-AERA`), pra não depender do `vendor_dlkm` do sistema.

Próximo passo: extrair `hos1/*.ko` + `vendor/firmware/goodix_*` do dump e colocar em `recovery/root/vendor/` (TODO).

## Sobre `sm84xx-common-AERA`: serve pro marble?

Não pra herdar direto. É pra copiar a lógica.

- `sm84xx-common` = Xiaomi SM8450/SM8475 (taro/cape). Marble = SM7475 (`PRODUCT_PLATFORM := ukee`).
- Incompatíveis: `BOARD_SUPER_PARTITION_SIZE` (marble 9663676416 vs common 9126805504), kernel, dtbo, display, WLAN, touch, câmera.
- Reaproveitável: padrão `AERA_*` (`AERA_LOAD_VENDOR_MODULES`, `AERA_ENABLE_WLAN`, `AERA_INCLUDE_CRYPTO_FBE`, decrypt, fastbootd, AVB spoof `99.87.36`), estrutura `twrp/recovery/root`, `BoardConfigCommon.mk`/`device-common.mk` como modelo.

## Build (quando manifest AERA 16.0 disponível)

```
export AERA_BUILD_DEVICE=marble
source build/envsetup.sh
lunch twrp_marble-eng
mka recoveryimage
```

## Layout

- `BoardConfig.mk` — arch, kernel, partições marble, AVB, crypto, módulos (com fix touch)
- `device.mk` — A/B, dynamic partitions, fastbootd, decrypt
- `aera_marble.mk` — produto AERA + UI 1080x2400
- `twrp_marble.mk` — compat TWRP/OFRP
- `recovery.fstab` — fstab first-stage (conferido com dump Ardjlon)
- `DUMP_INFO.md` — metadados do dump

## Créditos

- Ctapchuk (tree OFRP marble base)
- Ardjlon (build de referência que funciona; ramdisk analisado, sem tree pública)
- Nebrassy (base original citada nos changelogs)
- AERA Recovery Project (`android_bootable_recovery`, `dada-AERA`, `sm84xx-common-AERA`)
- pzqqt (autor Melt, explicação do bug de touch)
