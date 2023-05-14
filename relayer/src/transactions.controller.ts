import { Body, Controller, Post } from '@nestjs/common';
import { TransactionsService } from './transactions.service';

@Controller('transactions')
export class TransactionsController {
  constructor(private transactionsService: TransactionsService) {}

  @Post()
  async sendTransaction(@Body() body: any) {
    console.log('received signed transaction', body);
    return this.transactionsService.relayTransaction(body);
  }
}
