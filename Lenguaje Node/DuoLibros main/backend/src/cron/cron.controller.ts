import { Body, Controller, Get, Post } from '@nestjs/common';
import { CronService } from './cron.service';

@Controller('cron')
export class CronController {
  constructor(private readonly cronService: CronService) {}

  @Get()
  runCronJob() {
    return this.cronService.listCronJobs();
  }

  @Post('execute')
  executeCronJob(@Body() body: { jobName: string }) {
    return this.cronService.executeTimeOut(body.jobName);
  }
}
