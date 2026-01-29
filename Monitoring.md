# Monitoring

## Quick Setup for Temperatures (Important on Old Laptop)
Many monitoring tools need lm_sensors for CPU/motherboard temps:

```bash
sudo pacman -S lm_sensors
sudo sensors-detect --auto   # answer yes to most, but read carefully
sensors                  # test output
```

Then netdata will show temps automatically.