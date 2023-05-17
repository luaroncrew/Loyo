import { Component, ViewChild } from '@angular/core';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  // @ViewChild("chart") chart = {} as ChartComponent;
  // public chartOptions: Partial<ChartOptions>;
  title = 'BusinessLoyo';
  businessName = "Happy Pizza";
  address = "Via Giovanni Antonio Amadeo, 78, 20134 Milano MI, Italy";
  loyaltyPointsDistributed = 5613;
  loyaltyPointsSpent = 4513;
  rewardsDistributed = 891;
  businessAddress = 0x35979BDd030CF42508151FFEDd961263FC50133A;

}
