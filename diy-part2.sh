#!/bin/bash
# DIY 脚本：适配 TD22A11 V02 设备树
echo "适配 TD22A11 V02 (OneBox E02/R07 Pro) 设备树..."

# 下载并替换 RK3568 设备树
cat > target/linux/rockchip/dts/arm64/rk3568-onebox-e02.dts <<EOF
/dts-v1/;
#include <dt-bindings/gpio/gpio.h>
#include <dt-bindings/pinctrl/rockchip.h>
#include "rk3568.dtsi"

/ {
	model = "OneBox E02/R07 Pro (TD22A11 V02)";
	compatible = "onebox,e02", "rockchip,rk3568";

	chosen {
		stdout-path = "serial0:115200n8";
		bootargs = "console=ttyS0,115200 root=/dev/mmcblk0p2 rootwait rw";
	};

	aliases {
		serial0 = &uart0;
		serial2 = &uart2;
		serial3 = &uart3;
		ethernet0 = &gmac0;
		ethernet1 = &gmac1;
	};
};

&uart0 {
	pinctrl-names = "default";
	pinctrl-0 = <&uart0m1_xfer>;
	status = "okay";
};

&uart2 {
	pinctrl-names = "default";
	pinctrl-0 = <&uart2m1_xfer>;
	status = "okay";
};

&uart3 {
	pinctrl-names = "default";
	pinctrl-0 = <&uart3m1_xfer>;
	status = "okay";
};

&gmac0 {
	phy-handle = <&rgmii_phy0>;
	phy-mode = "rgmii-id";
	snps,reset-gpio = <&gpio0 RK_GPIO_D6 GPIO_ACTIVE_LOW>;
	status = "okay";
};

&gmac1 {
	phy-handle = <&rgmii_phy1>;
	phy-mode = "rgmii-id";
	status = "okay";
};

&mdio0 {
	rgmii_phy0: phy@0 {
		compatible = "ethernet-phy-ieee802.3-c22";
		reg = <0x0>;
	};
	rgmii_phy1: phy@1 {
		compatible = "ethernet-phy-ieee802.3-c22";
		reg = <0x1>;
	};
};
EOF

# 刷新配置
make defconfig
echo "设备树适配完成！"
