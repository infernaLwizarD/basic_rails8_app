require 'pp'

module Kernel
  CPUTS_PALETTE = String.colors
                        .reject { |c| %i[black default gray].include?(c) }
                        .freeze

  def cputs(*args, color: :black, palette: CPUTS_PALETTE)
    return if palette.empty?

    args.each_with_index do |arg, idx|
      bg = palette[idx % palette.size]

      output = if arg.is_a?(String) && arg.present?
                 arg
               elsif arg.respond_to?(:pretty_inspect) && !arg.is_a?(String)
                 arg.pretty_inspect.chomp
               else
                 arg.inspect
               end

      output.to_s.split("\n", -1).each do |line|
        puts line.colorize(color: color, background: bg)
      end
    end

    nil
  end
end
