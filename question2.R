p2 <- ggplot(
  mode_accuracy,
  aes(
    x = mean_abs_error,
    y = reorder(mode, mean_abs_error)
  )
) +
  geom_col(width = 0.7) +
  geom_text(
    aes(label = round(mean_abs_error, 2)),
    hjust = -0.2,
    size = 3.5
  ) +
  labs(
    title = "Polling Accuracy by Survey Mode",
    subtitle = "Lower error indicates estimates closer to actual election results",
    x = "Mean Absolute Polling Error (percentage points)",
    y = "Survey Mode"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(
      size = 15,
      face = "bold"
    ),
    plot.subtitle = element_text(
      size = 10
    ),
    panel.grid.major.y = element_blank()
  ) +
  expand_limits(
    x = max(mode_accuracy$mean_abs_error) * 1.12
  )

print(p2)



