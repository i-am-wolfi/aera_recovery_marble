# Dump info — marble (Ardjlon OrangeFox, slot _a)

- Data: 2026-10-15 via `adb shell su -c 'dd if=/dev/block/by-name/recovery_a ...'` (root KernelSU)
- Arquivo local: `~/recovery/recovery_a.img` (104857600 bytes)
- sha256: `0ddc89c60d42e2563df6bb293714f2eeec73d11da852274103962fe9fc5b1932`
- bootimg: header v4, kernel_size=0, ramdisk LZ4 40427254 bytes, os 99.87.36 patch 2099-12
- Ramdisk extraído: `~/recovery/ramdisk-extract` (`lz4 -dc unpacked/ramdisk | cpio -idm`)
- Build: `fox_marble-eng 99.87.36 SP2A.220405.004 76 test-keys`, `ro.system.build.date=Thu Feb 26 11:37:46 IST 2026`, base `fox_12.1` (`/home/ardjlon/rms/fox_12.1/...`), `FOX_CODE_BASE=2026-02-08`
- Sistema no aparelho: HyperOS OS3.0.3.0.VMRMIXM, Android 15, slot `_a`

## Touch

- Ramdisk recovery embarca `vendor/lib/modules/hos1/` + `miui14/`, ambos:
  `adsp_loader_dlkm goodix_core gpr_dlkm mdt_loader panel_event_notifier pdr_interface q6_notifier_dlkm q6_pdr_dlkm qcom_glink qcom_glink_smem qcom_pil_info qcom_q6v5 qcom_q6v5_pas qcom_ramdump qcom_smd qcom_sysmon qmi_helpers rproc_qcom_common snd_event_dlkm spf_core_dlkm xiaomi_touch`
- Firmwares: `vendor/firmware/goodix_firmware_TM*.bin`, `goodix_cfg_group_TM*.bin`, `goodix_test_limits_255_TM*.csv`
- Vendor do sistema (HyperOS 3.0) tem em `/vendor/lib/modules/`: `atmel_mxt_ts.ko focaltech_fts.ko goodix_3626.ko xiaomi_touch.ko` (+ resto do SoC). Não tem `goodix_core.ko` — por isso a base Ctapchuk (só `goodix_core.ko` do sistema) quebra e a do Ardjlon (embarcado) funciona.

## TODO para fechar a bring-up

1. Copiar `hos1/*.ko` + `vendor/firmware/goodix_*` do dump para `recovery/root/vendor/` nesta tree.
2. Colocar kernel prebuilt em `prebuilt/kernel` (extrair do sistema ou pedir ao Ardjlon o kernel stock usado).
3. `security/otacert` (vazio por enquanto).
4. Testar build `mka recoveryimage` no manifest AERA 16.0 e `fastboot flash recovery_ab`.
