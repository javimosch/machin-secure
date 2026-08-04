import { DomSanitizer } from "@angular/platform-browser";
constructor(private sanitizer: DomSanitizer) {}
this.html = this.sanitizer.bypassSecurityTrustHtml(userInput);
<div [innerHTML]="html"></div>
eval(userInput);
new Function(userInput)();
import { HttpInterceptor, provideHttpClient } from "@angular/common/http";
