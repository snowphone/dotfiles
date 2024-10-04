# Backup and Restore


## Backup

```bash
defaults read com.mowglii.ItsycalApp > $HOME/.config/itsycal/config.plist
```

## Restore

```bash
defaults import com.mowglii.ItsycalApp $HOME/.config/itsycal/config.plist
```
