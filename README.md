# About
Aku capek setup VPS IPv6 setelah VPS terinstall, makanya kubuatkan saja script startup ini coy.

# Install
Jangan lupa posisi direktori ada di `/root`
```
wget -N https://raw.githubusercontent.com/wawan-ikhwan/startup-script-ipv6-ubuntu/main/ipv6-vps-ubuntu-startup.sh && chmod +x ipv6-vps-ubuntu-startup.sh && ./ipv6-vps-ubuntu-startup.sh <PW>
 ```

# Password
Cuman aku sadja yang tau password config rclone, itu diawali dengan karakter `T` dan diakhiri dengan karakter `_`.

# Setup Zero Trust WARP Team
Jika Anda mau masuk WARP tim saya agar bisa satu jaringan, saya akan beri tau nama organisasinya, kontak saya secara pribadi. Berikut adalah bagaimana Anda dapat mengganti IP private VPS Anda agar kita satu jaringan dengan command Zero Trust di bawah ini.
```
wget -N https://raw.githubusercontent.com/wawan-ikhwan/startup-script-ipv6-ubuntu/main/setup-warp-team.sh && chmod +x setup-warp-team.sh && ./setup-warp-team.sh <Team Token> <Nama Perangkat>
```

# Mendapatkan Token Team
Dia ada di link ini, isi nama organisasi yang valid, kalau mau tau nama organisasi saya, kontak saya secara pribadi:
[GET WARP TOKEN TEAM](https://web--public--warp-team-api--coia-mfs4.code.run)