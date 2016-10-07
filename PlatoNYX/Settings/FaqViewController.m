//
//  FaqViewController.m
//  PlatoNYX
//
//  Created by mobilestar on 10/6/16.
//  Copyright © 2016 marc. All rights reserved.
//

#import "FaqViewController.h"
#import "FaqTableViewCell.h"

@interface FaqViewController ()<UITableViewDelegate, UITableViewDataSource> {
    
    NSMutableArray *faqArray;
}

@end

@implementation FaqViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
}

- (void)initData {
    faqArray = [[NSMutableArray alloc] init];
    faqArray = [@[
         [@{@"question" : @"PlatoNYX nedir?", @"answer" : @"Yoğun ve yorucu şehir hayatında aşkı bulmak giderek zorlaşırken, bize bu konuda yardımcı olmayı vaad eden ancak içine girdiğimizde 5 saniyede 10 profil fotoğrafına bakmamız beklenen veya bir miktar soruyla bizi \"ruh ikizimiz\" ile buluşturacağını iddia eden online platformlar arasında sıkışıp kaldık. Oysa ki aşkın nefes almak için geniş alanlara ihtiyacı vardır. Bu mottoyla yola çıkan PlatoNYX, Türkiye’nin ilk “Offline Dating Uygulaması”dır"} mutableCopy],
         [@{@"question" : @"Offline Dating ne demek?", @"answer" : @"\"En iyi algoritma insanın kendi sezgileridir\" inancıyla yola çıkan PlatoNYX, sizi bir kişiyle eşleştirmek yerine, kıstaslarını sizin belirleyeceğiniz bir grup insanla keyifli ve eğlenceli etkinliklere gönderir. Böylece, kimi beğenip, kimi beğenmeyeceğinize algoritmalar değil, o kişileri görerek, konuşarak bizzat kendiniz karar verirsiniz. Kişiler arasındaki etkileşim online ortamda değil, gerçek hayatın içinde olduğu için de buna \"Offline Dating\" denir."} mutableCopy],
         [@{@"question" : @"Uygulamaya üye oldum. Şimdi ne yapmalıyım?", @"answer" : @"Öncelikle yapmanız gereken şey, Profil fotoğrafınızı oluşturmak ve ekranın sağ üstündeki Ayarlar ikonuna basarak, Profil Ayarlarınızı ve Tercihlerinizi belirlemek. Bunu yaptıktan sonra, biz sizin için uygun olduğunu düşündüğümüz etkinlikleri Uygulama ana sayfanızdan önermeye başlayacağız. İlginizi çeken etkinliklerin ayrıntısına bakabilir ve o etkinliğe katılmak isterseniz etkinlik sayfasındaki “Katıl” tuşuna basabilirsiniz. Katılacağınız etkinliklerin ayrıntıları, üye olurken vermiş olduğunuz e-posta adresinize gönderilecektir. Son olarak, Katıl tuşuna bastıktan sonra o etkinliğe sizden başka kimlerin katılıyor olduğunu da görebilirsiniz."} mutableCopy],
         [@{@"question" : @"Katılacağım etkinlikleri nereden görebilirim?", @"answer" : @"Katılacağınız etkinliklere Etkinliklerim menüsünden ulaşabilir, katılmaktan vazgeçerseniz aynı yerdeki “İptal” tuşuna basabilirsiniz. İptal ettiğiniz etkinlik, fikrinizi değiştirme ihtimalinize karşı yeniden profil sayfanızda size önerilecektir."} mutableCopy],
         [@{@"question" : @"PlatoNYX ücretli mi?", @"answer" : @"Şu an Beta aşamasında olduğumuz için uygulama tamamen ücretsizdir. Ancak ilerleyen aşamalarda uygulamamızın ücretli olmasını öngörmekteyiz."} mutableCopy],
         [@{@"question" : @"Etkinlikler ücretli mi?", @"answer" : @"Evet. Ancak bu ücreti bize değil, etkinliğe gittiğinizde ilgili işletmeye ödüyor olacaksınız."} mutableCopy],
         [@{@"question" : @"Diğer kullanıcılara uygulama içinden mesaj atabiliyor muyuz?", @"answer" : @"Hayır. Online, değil offline ortamdaki etkileşimi baz aldığımız için uygulama içinden kullancılara mesaj atmanız mümkün değil. Biz istiyoruz ki, dışarı çıkın, insanlar ile yüz yüze tanışın, kimi sevip kimi sevmeyeceğinize 3-5 cümlelik beylik mesajlarla değil, görerek, tanıyarak kendiniz karar verin."} mutableCopy],
         [@{@"question" : @"Etkinliklere katıldıktan sonra neler oluyor?", @"answer" : @"Etkinliklere katıldıktan sonra sizden uygulama üzerinden etkinliğe katılmış diğer kullanıcıları “Katıldığım Etkinlikleri Oyla” kısmında oylamanızı istiyoruz. Burada etkinliğe katılmış kişiler arasından en fazla 2 kişiyi beğenebilirsiniz. Eğer ki sizin beğendiğiniz kullanıcı, aynı şekilde sizi beğenmişse, işte o zaman sadece ikinize özel birebir date etkinliği öneriyoruz. Bu birebir etkinliğe gitmek isterseniz, yine aynı şekilde etkinlik sayfasından “Katıl” tuşuna basmanız yeterli. Ayrıntılar yine e-postanıze gelecek."} mutableCopy],
         [@{@"question" : @"PlatoNYX etkinlikleri şu an hangi şehirlerde var?", @"answer" : @"Pilot bölge olarak şu an sadece İstanbul’daki etkinlikleri önerebiliyoruz ancak en kısa sürede diğer şehirlere de ulaşmak planlarımız arasında."} mutableCopy],
         [@{@"question" : @"Uygulamada bazı hatalar var. Neden?", @"answer" : @"Evet farkındayız ve şu an henuz Beta aşamasında olduğumuz için bu konuda hoş görünüze sığınıyoruz. Ancak gördüğünüz hataları bize İletişim bölümünden aktarırsanız, hızlıl bir şekilde çözmek için elimizden geleni yaparız."} mutableCopy],
         [@{@"question" : @"Katıldığım etkinlik, mekan veya katılan kişilerle ilgili bir şikayetim olursa ne yapmalıyım?", @"answer" : @"Şikayetlerinizi bize İletişim bölümünden bildirebilirsiniz."} mutableCopy]
    ] mutableCopy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [faqArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     FaqTableViewCell *cell = (FaqTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"FaqTableViewCell"];

    cell.facNumlbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)indexPath.row + 1];
    cell.questionlbl.text = [[faqArray objectAtIndex:indexPath.row] objectForKey:@"question"];
    cell.contentlbl.text = [[faqArray objectAtIndex:indexPath.row] objectForKey:@"answer"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
