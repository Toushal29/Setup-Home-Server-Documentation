# Monitoring
## Quick Setup for Temperatures (Important on Old Laptop)
Most temperature monitoring tools (including netdata) depend on `lm-sensors` for CPU/motherboard temps.

```bash
sudo apt install -y lm-sensors
sudo sensors-detect --auto     # answer YES to most questions
sensors                        # verify output
```

Then netdata will show temps automatically.