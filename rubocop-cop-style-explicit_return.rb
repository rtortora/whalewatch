require 'rubocop'
require 'pry'
require 'pry-nav'

module RuboCop
  module Cop
    module Style
      class ExplicitReturn < Cop
        include OnMethodDef

        MSG = 'Explicit `return` missing.'

        private

        # def autocorrect(node)
        #   lambda do |corrector|
        #     unless arguments?(node.children)
        #       corrector.replace(node.loc.expression, 'nil')
        #       next
        #     end

        #     if node.children.size > 1
        #       kids = node.children.map { |child| child.loc.expression }
        #       corrector.insert_before(kids.first, '[')
        #       corrector.insert_after(kids.last, ']')
        #     end
        #     return_kw = range_with_surrounding_space(node.loc.keyword, :right)
        #     corrector.remove(return_kw)
        #   end
        # end

        def arguments?(args)
          return false if args.empty?
          return true if args.size > 1

          !args.first.begin_type? || !args.first.children.empty?
        end

        def on_method_def(_node, _method_name, _args, body)
          return unless body

          binding.pry
          if body.type != :return
            check_return_node(body)
          elsif body.type == :begin
            expressions = *body
            last_expr = expressions.last

            if last_expr && last_expr.type == :return
              check_return_node(last_expr)
            end
          end
        end

        def check_return_node(node)
          return if cop_config['AllowMultipleReturnValues'] &&
                    node.children.size > 1
          # binding.pry
          add_offense(node, :expression)
        end
      end
    end
  end
end
