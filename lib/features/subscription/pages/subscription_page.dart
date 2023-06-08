import 'package:chat_buddy/common/utils/app_utility.dart';
import 'package:chat_buddy/exceptions/http_exception.dart';
import 'package:chat_buddy/features/subscription/widgets/subscription_plan.dart';
import 'package:chat_buddy/providers/auth_provider.dart';
import 'package:chat_buddy/providers/subscription_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubscriptionPage extends StatelessWidget {
  static const routeName = '/subscription-page';

  const SubscriptionPage({super.key});

  Future<void> _loadPlans(BuildContext context) async {
    try {
      await Provider.of<SubscriptionProvider>(context, listen: false)
          .fetchPlans();
    } on HttpException catch (e) {
      AppUtility.showErrorDialog(
        context: context,
        message: e.message,
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  // margin: const EdgeInsets.all(8),
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(left: 12, top: 12),
                  child: const SizedBox(
                    height: 30,
                    child: FittedBox(child: Icon(Icons.cancel_outlined)),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Column(
                children: [
                  Consumer<AuthProvider>(
                    builder: (_, authUser, __) => authUser.hasUsedFreeTrial!
                        ? const Text(
                            'Unlock Full Access!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                            ),
                          )
                        : const Text(
                            'Begin Your One Month Free Subscription',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                  ),
                  // SizedBox(height: 30),
                  const ListTile(
                    title: Text(
                      'Answers From GPT-3',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                    ),
                    subtitle: Text(
                      'guaranteed accurate and detailed responses',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  const ListTile(
                    title: Text(
                      'Group Chats',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                    ),
                    subtitle: Text(
                      'Join and create groups with friends',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const ListTile(
                    title: Text(
                      'Unlimited Chats',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                    ),
                    subtitle: Text(
                      'Create & preserve chat history forever',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const ListTile(
                    title: Text(
                      'No Ads',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                    ),
                    subtitle: Text(
                      'Guaranteed Ad free experience',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              // const SizedBox(height: 20),
              Expanded(
                child: FutureBuilder(
                  future: _loadPlans(context),
                  builder: (context, _) => Consumer<SubscriptionProvider>(
                    builder: (_, plan, __) => ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, _) => const SizedBox(
                        height: 0,
                      ),
                      itemCount: plan.plans.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SubscriptionPlan(
                          name: plan.plans[index].name,
                          interval: plan.plans[index].interval,
                          amount: plan.plans[index].amount,
                          onTap: () async {
                            try {
                              await Provider.of<SubscriptionProvider>(context,
                                      listen: false)
                                  .subscribe(context, plan.plans[index].code);
                            } on HttpException catch (e) {
                              AppUtility.showErrorDialog(
                                context: context,
                                message: e.toString(),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
