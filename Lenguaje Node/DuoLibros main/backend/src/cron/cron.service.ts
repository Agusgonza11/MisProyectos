import { Injectable, Logger } from '@nestjs/common';
import { SchedulerRegistry } from '@nestjs/schedule';

@Injectable()
export class CronService {
  private readonly logger = new Logger(CronService.name);

  constructor(private schedulerRegistry: SchedulerRegistry) {}

  private timeouts = new Map<string, { callback: () => Promise<void> }>();

  addTask(name: string, milliseconds: number, callback: () => Promise<void>) {
    this.logger.log(`Adding cron job "${name}"`);
    const timeout = setTimeout(callback, milliseconds);
    this.timeouts.set(name, { callback });
    this.schedulerRegistry.addTimeout(name, timeout);
  }

  listCronJobs() {
    const jobs = this.schedulerRegistry.getTimeouts();
    return jobs;
  }

  async executeTimeOut(name: string) {
    const timeout = this.schedulerRegistry.getTimeout(name);
    if (timeout) {
      const { callback } = this.timeouts.get(name);

      await callback();

      clearTimeout(timeout);
      this.schedulerRegistry.deleteTimeout(name);
      this.logger.log(`Cron job "${name}" executed`);
    }
  }

  async removeTimeout(name: string) {
    try {
      const timeout = this.schedulerRegistry.getTimeout(name);
      if (timeout) {
        clearTimeout(timeout);
        this.schedulerRegistry.deleteTimeout(name);
        this.logger.log(`Cron job "${name}" removed`);
      }
    } catch (error) {
      this.logger.error(`Error removing cron job "${name}": ${error}`);
    }
  }
}
