package dev.mowerbot.timer;

import com.intellij.ide.actions.RevealFileAction;
import com.intellij.openapi.Disposable;
import com.intellij.openapi.project.Project;
import com.intellij.openapi.util.Disposer;
import com.intellij.openapi.wm.ToolWindow;
import com.intellij.openapi.wm.ToolWindowFactory;
import com.intellij.ui.components.JBLabel;
import com.intellij.ui.components.JBPanel;
import com.intellij.ui.content.ContentFactory;
import java.awt.BorderLayout;
import java.awt.GridLayout;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JPanel;
import javax.swing.Timer;
import org.jetbrains.annotations.NotNull;

public final class TimingToolWindow implements ToolWindowFactory {
    @Override
    public void createToolWindowContent(@NotNull Project project, @NotNull ToolWindow toolWindow) {
        Panel panel = new Panel(project.getService(TimingService.class));
        var content = ContentFactory.getInstance().createContent(panel, "", false);
        Disposer.register(content, panel);
        toolWindow.getContentManager().addContent(content);
    }

    private static final class Panel extends JBPanel<Panel> implements Disposable {
        private final Timer refresh;

        Panel(TimingService recorder) {
            super(new BorderLayout(8, 8));
            JPanel controls = new JPanel(new GridLayout(0, 1, 4, 4));
            JBLabel status = new JBLabel();
            JBLabel elapsed = new JBLabel();
            JButton start = button("Start task (before prompt)", recorder::start);
            JButton complete = button("Complete (agent ready)", () -> recorder.finish(false));
            JButton cancel = button("Cancel task", () -> recorder.finish(true));
            JComboBox<TaskTimer.Phase> phases = new JComboBox<>(TaskTimer.Phase.values());
            JButton record = button("Begin selected phase / checkpoint",
                    () -> recorder.phase((TaskTimer.Phase) phases.getSelectedItem()));
            JButton report = button("Reveal latest report",
                    () -> RevealFileAction.openFile(recorder.reportPath().toFile()));
            controls.add(start);
            controls.add(phases);
            controls.add(record);
            controls.add(complete);
            controls.add(cancel);
            controls.add(report);
            controls.add(status);
            controls.add(elapsed);
            add(controls, BorderLayout.NORTH);
            add(new JBLabel("<html>Manual task boundaries, not Copilot lifecycle hooks.<br>"
                    + "Project editor edits and IDE runs are observed automatically.<br>"
                    + "No prompts, code, paths, commands or outputs are recorded.<br>"
                    + "Phases are manual; unobserved gaps are not root causes.</html>"), BorderLayout.SOUTH);
            Runnable update = () -> {
                boolean active = recorder.isActive();
                start.setEnabled(!active);
                complete.setEnabled(active);
                cancel.setEnabled(active);
                phases.setEnabled(active);
                record.setEnabled(active);
                report.setEnabled(recorder.reportPath() != null);
                status.setText(recorder.status());
                elapsed.setText(active ? "Elapsed: " + recorder.elapsedSeconds() + " s (includes waits)" : "");
            };
            update.run();
            refresh = new Timer(500, event -> update.run());
            refresh.start();
        }

        private static JButton button(String label, Runnable action) {
            JButton button = new JButton(label);
            button.addActionListener(event -> action.run());
            return button;
        }

        @Override
        public void dispose() { refresh.stop(); }
    }
}
