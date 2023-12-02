import 'package:eventify/styles/color_style.dart';
import 'package:flutter/material.dart';

class TermsAndConditionScreen extends StatefulWidget {
  const TermsAndConditionScreen({super.key});

  @override
  State<TermsAndConditionScreen> createState() =>
      _TermsAndConditionScreenState();
}

class _TermsAndConditionScreenState extends State<TermsAndConditionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: ColorStyle.secondaryTextColor,
            ),
          ),
          backgroundColor: ColorStyle.whiteColor,
          foregroundColor: ColorStyle.secondaryTextColor,
          elevation: 0.5,
          title: const Text(
            "Terms and Conditions",
            style: TextStyle(
                color: ColorStyle.primaryTextColor,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce non diam mattis, placerat ante vel, suscipit lectus. Interdum et malesuada fames ac ante ipsum primis in faucibus. Praesent tempus, risus at tempor fringilla, sapien est eleifend magna, mollis feugiat sapien sem vitae dolor. Donec id facilisis nisl, ac luctus lectus. Mauris fringilla mollis mattis. Nam non maximus metus, porttitor rutrum dolor. Curabitur auctor, nisi quis lacinia porttitor, sapien libero lacinia mauris, vitae consequat mauris velit vitae nunc. Nulla ac placerat nulla. Donec sit amet nunc eu nibh consequat bibendum. Vivamus tellus odio, faucibus vitae volutpat et, vestibulum fringilla nisl. Aliquam viverra orci eros. Nunc sit amet magna tempor ante ultrices maximus at egestas dolor.Aliquam at dapibus lectus, at elementum odio. Curabitur venenatis, magna sit amet facilisis auctor, dolor ante facilisis lacus, quis placerat tortor libero non ligula. Mauris eu tellus scelerisque, condimentum odio vel, sodales dui. Pellentesque suscipit vehicula lorem ac varius. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. In enim nisi, gravida id felis id, imperdiet elementum lorem. Interdum et malesuada fames ac ante ipsum primis in faucibus. In malesuada tristique hendrerit.Nam tempus egestas tellus, lacinia gravida diam. Nunc quis auctor ipsum. Vestibulum vel tortor ut metus fermentum dapibus eu pharetra leo. Donec pharetra eget nibh in molestie. Nullam sit amet hendrerit elit. Morbi gravida posuere odio vel viverra. Ut sagittis ipsum nulla, sed volutpat ipsum blandit sodales. Vestibulum blandit, ligula vitae luctus porttitor, mauris tortor lacinia odio, sit amet fringilla turpis sem sagittis magna. Sed sit amet rhoncus quam, pretium viverra quam. Mauris arcu lacus, lobortis sed nisl sed, ullamcorper lobortis nisi. Aenean at diam porta, cursus dolor id, pulvinar libero. Vestibulum vitae velit tincidunt, ullamcorper ipsum et, mollis orci. Etiam posuere, odio eu cursus luctus, ante metus pellentesque massa, sodales pulvinar odio lacus at leo. Vivamus facilisis tristique lacinia. Morbi rhoncus ipsum a molestie semper.Nullam sapien libero, porttitor vel diam nec, congue efficitur neque. In nec hendrerit turpis. Integer in velit ut lorem aliquet sodales. Etiam varius est ligula, non pretium arcu venenatis ultricies. Donec ut aliquet libero. Pellentesque eu malesuada tortor, eu hendrerit magna. Nullam malesuada leo a ligula ullamcorper, sit amet efficitur nisl rutrum. Pellentesque euismod, mi in euismod semper, tellus dolor laoreet urna, ut iaculis urna mi in elit. Curabitur condimentum dolor porta orci finibus mollis. Sed at viverra velit, nec feugiat est. Nam mattis ipsum a ipsum egestas, non laoreet dui tincidunt. Nulla nec suscipit quam. Nullam turpis nunc, tincidunt a dolor ut, convallis fringilla nisl. Vivamus sed interdum enim. In vel consectetur neque. Morbi sit amet erat ut arcu faucibus placerat non ac mi.Morbi tincidunt in erat eu pretium. Vestibulum mollis quam dolor, et congue turpis pretium non. Donec ornare fermentum venenatis. In convallis fringilla erat vitae vehicula. Duis malesuada augue in cursus pretium. Cras accumsan velit at pharetra laoreet. In rhoncus, nisi ultrices iaculis sollicitudin, urna velit aliquet tortor, vel sodales massa nisl eget erat. Nulla facilisi. Vivamus feugiat libero ligula. Phasellus sit amet quam sit amet lorem tempus scelerisque. Sed felis nunc, volutpat in mattis vitae, gravida ac nulla. Donec hendrerit et sem a tristique.'),
          ),
        ));
  }
}
