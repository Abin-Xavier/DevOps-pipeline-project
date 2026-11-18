import { Component, OnInit, signal } from '@angular/core';

interface Task {
  id: number;
  title: string;
  done: boolean;
}

@Component({
  selector: 'app-root',
  template: `
    <main style="max-width:480px;margin:2rem auto;font-family:sans-serif">
      <h1>Task Tracker</h1>
      <p>API status: <strong>{{ status() }}</strong></p>
      <ul>
        @for (t of tasks(); track t.id) {
          <li>{{ t.done ? '✅' : '⬜' }} {{ t.title }}</li>
        }
      </ul>
    </main>
  `,
})
export class App implements OnInit {
  status = signal('checking...');
  tasks = signal<Task[]>([]);
  private api = 'http://localhost:5000';

  async ngOnInit() {
    try {
      const health = await fetch(`${this.api}/health`).then(r => r.json());
      this.status.set(health.status);
      this.tasks.set(await fetch(`${this.api}/api/tasks`).then(r => r.json()));
    } catch {
      this.status.set('API unreachable');
    }
  }
}